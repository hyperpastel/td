import std::io;
import libc;
import libc::termios;

fn void setup_terminal (libc::termios::Termios *original) {
    libc::termios::tcgetattr(0, original);

    libc::termios::Termios term;
    term.c_lflag &= ~(Tc_lflags){.echo, .icanon, .isig, .iexten};
    term.c_iflag &= ~(Tc_iflags){.ixon, .icrnl, .brkint, .inpck, .istrip};
    term.c_oflag.opost = false;
    term.c_cflag.csize = CS8;
    term.c_cc[(int) libc::termios::Cc.VMIN] = 0;
    term.c_cc[(int) libc::termios::Cc.VTIME] = 1;

    libc::termios::tcsetattr (0, libc::termios::Tcactions.TCSAFLUSH, &term);

    String code_load_alt_screen = "\x1b[?1049h";
    String code_hide_cursor = "\x1b[?25l";

    io::printf("%s%s", code_load_alt_screen, code_hide_cursor);
}

fn void reset_terminal(libc::termios::Termios *original) {
    libc::termios::tcsetattr(0, libc::termios::Tcactions.TCSAFLUSH, original);

    String code_unload_alt_screen = "\x1b[?1049l";
    String code_show_cursor = "\x1b[?25h";

    io::printf("%s%s", code_unload_alt_screen, code_show_cursor);
}

fn void reset_line() {
    io::print("\x1b[2K\r");
}

fn void main (String[] args) {
    libc::termios::Termios original;

    setup_terminal(&original);
    defer reset_terminal(&original);

    while (true) {
        char c = '\0';
        if (libc::read(0, &c, 1) == -1 && libc::errno() != libc::errno::EAGAIN) {
            return;
        }

        if (c == 'q') {
            return;
        }

        reset_line();
        libc::fflush(libc::stdout());
    }
}
