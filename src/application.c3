module application;

import task;
import termcodes;
import winsize;

import std::io;

import libc::termios;

struct Viewport @private{
    usz start;
    usz length;
    usz index;
}

struct Application {
    TaskList tasks;
    Viewport view;
    WinSize window_size;
    Termios term;
}

fn void Application.set_task_length(&self, usz length) {
    self.view.length = length;
}

fn void Application.set_window_size(&self) {
    self.window_size = winsize::get_window_size();
}

fn void Application.setup_terminal (&self) {
    self.term.get_attr(0);

    Termios term;
    term.c_lflag &= ~(Tc_lflags){.echo, .icanon, .isig, .iexten};
    term.c_iflag &= ~(Tc_iflags){.ixon, .icrnl, .brkint, .inpck, .istrip};
    term.c_oflag.opost = false;
    term.c_cflag.csize = CS8;
    term.c_cc[(int) Cc.VMIN] = 0;
    term.c_cc[(int) Cc.VTIME] = 1;

    term.set_attr (0, TCSAFLUSH);

    io::printf("%s%s\r", termcodes::LOAD_ALT_SCREEN, termcodes::HIDE_CURSOR);
}

fn void Application.reset_terminal(&self) {
    self.term.set_attr(0, TCSAFLUSH);
    io::printf("%s%s\r", termcodes::UNLOAD_ALT_SCREEN, termcodes::SHOW_CURSOR);
}

fn String Application.render(&self, Allocator alloc) {
    usz result_size =(self.window_size.cols * self.window_size.rows) / 4;

    DString result = dstring::new_with_capacity(alloc, result_size);
    result.appendf("%s%s",termcodes::CLEAR_SCREEN, termcodes::RESET_CURSOR);
    result.appendf("%sYour Tasks:\r\n%s", termcodes::FG_RED, termcodes::FG_DEFAULT);

    usz last_line = ((usz) self.view.start + self.view.length);
    if (last_line > self.tasks.len()) {
        last_line = self.tasks.len();
    };

    DString item = dstring::new_with_capacity(tmem, self.window_size.cols);
    Task[] tasks = self.tasks.array_view()[self.view.start..last_line - 1];

    foreach (index, &task : tasks) {
        // current selected text should be highlighted
        if (index == self.view.index) {
            item.appendf("%s%s%s", termcodes::BG_GREEN, task.text, termcodes::BG_DEFAULT);
        } else {
            item.append(task.text);
        }

        if (task.completed)  {
            result.appendf("%s%s%s", termcodes::SET_STRIKETHROUGH, item, termcodes::REM_STRIKETHROUGH);
        } else {
            result.append(item);
        }

        result.append("\r\n");
        item.clear();
    }

    return result.str_view();
}

fn void Application.toggle_current(&self) {
    usz current_index = self.view.start + self.view.index;
    self.tasks[current_index].toggle();
}

fn void Application.scroll_up(&self) {
    // if we've hit the top of the viewport and scroll up...
    if (self.view.index == 0) {
        // ... only move if we still have elements before
        if (self.view.start - 1 >= 0) {
            self.view.start--;
        }
    } else {
        self.view.index--;
    }
}

fn void Application.scroll_down(&self) {
    // if we've hit the bottom of the viewport and scroll down...
    if (self.view.index + 1 == self.view.length) {
        // ... only move if we still have elements after
        if (self.view.start + self.view.length < self.tasks.len()) {
            self.view.start++;
        }
    } else if (self.view.index + 1 < self.tasks.len()) {
        self.view.index++;
    }
}
