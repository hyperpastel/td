module winsize;

import termcodes;

import std::io;
import std::thread;
import std::time;

import libc;

struct WinSize {
    CUShort rows;
    CUShort cols;
    CUShort[2] unused;   /* unused */
}

const CInt TIOCGWINSZ = 0x5413;

fn WinSize get_window_size() {
    WinSize result;

    bool ioctl_fail = libc::ioctl(libc::STDOUT_FD, TIOCGWINSZ, &result) == -1 || result.cols == 0;
    if (ioctl_fail) {
        return fallback();
    };
    return result;
}

// In case ioctl is not available
fn WinSize fallback() {
    io::printf("%s%s%s", termcodes::CURSOR_DOWN, termcodes::CURSOR_RIGHT, termcodes::GET_CURSOR_POSITION); 
    libc::fflush(libc::stdout());

    char[32] buf;
    WinSize result;

    for (uint i = 0 ; i < buf.len - 1; i++) {
        if (libc::read(libc::STDIN_FD, &buf[i], 1) != -1) { break; }
        if (buf[i] == 'R') { 
            buf[i] = '\0';
            break; 
        }
    }

    if (buf[0] != '\x1b' || buf[1] != '[') return result;
    libc::sscanf(&buf[2], "%d;%d", &result.rows, &result.cols);
    thread::sleep(time::SEC);

    return result;
}
