import application;
import winsize;
import task;

import std::io;
import std::thread;
import std::time;

import libc;
import libc::termios;

fn void main (String[] args) {

    Task [] tasks = {
       (Task){ .text = "am-a-do", .completed = true },
       (Task){ .text = "one love / people get ready", .completed = true },
       (Task){ .text = "is this love", .completed = true },
       (Task){ .text = "i shot the sheriff", .completed = true },
       (Task){ .text = "could you be loved", .completed = true },
       (Task){ .text = "stop that train - jamaican version", .completed = true },
       (Task){ .text = "buffalo soldier", .completed = true },
       (Task){ .text = "natty dread", .completed = true },
       (Task){ .text = "pass it on", .completed = true },
       (Task){ .text = "kinky reggae", .completed = true },
       (Task){ .text = "so much trouble in the world", .completed = true },
       (Task){ .text = "waiting in vain", .completed = true },
       (Task){ .text = "satisfy my soul", .completed = true },
       (Task){ .text = "small axe", .completed = true },
    };

    Application app;   
    app.setup_terminal();
    defer app.reset_terminal();

    app.set_task_length(10);
    app.set_window_size();

    app.tasks.init_with_array(tmem, tasks);

    char c;
    while (true) {
        c = '\0';
        if (libc::read(libc::STDIN_FD, &c, 1) == -1 && libc::errno() != errno::EAGAIN) {
            return;
        }

        switch (c) {
            case 'j': 
                app.scroll_down();
            case 'k':
                app.scroll_up();
            case 'q':
                return;
            case 't':
                app.toggle_current();
            };

        io::printf("%s", app.render(tmem));
        libc::fflush(libc::stdout());
    }
}
