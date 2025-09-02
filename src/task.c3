module task;

import std::collections::list;

struct Task {
    String text;
    bool completed;
}

fn void Task.toggle (Task *task) {
    task.completed = !task.completed;
}

alias TaskList = List { Task };

// TODO Loading logic
