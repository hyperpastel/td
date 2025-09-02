module termcodes;

const String LOAD_ALT_SCREEN = "\x1b[?1049h";
const String UNLOAD_ALT_SCREEN = "\x1b[?1049l";
const String SHOW_CURSOR = "\x1b[?25h";
const String HIDE_CURSOR = "\x1b[?25l";
const String CLEAR_SCREEN = "\x1b[2J";
const String RESET_CURSOR = "\x1b[H";
const String BG_GREEN = "\x1b[1;42m";
const String BG_DEFAULT = "\x1b[1;49m";
const String FG_RED = "\x1b[1;31m";
const String FG_DEFAULT = "\x1b[1;39m";
const String SET_STRIKETHROUGH = "\x1b[9m";
const String REM_STRIKETHROUGH = "\x1b[29m";
const String CURSOR_DOWN = "\x1b[999C";
const String CURSOR_RIGHT = "\x1b[999B";
const String GET_CURSOR_POSITION = "\x1b[6n";
