module task;

import std::collections::list;

struct Task {
    String text;
    bool completed;
}

fn void Task.toggle (&self) {
    self.completed = !self.completed;
}

alias TaskList = List { Task };

// TODO Loading logic
