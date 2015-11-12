var stack = [];

function push(page) {
    stack.push(page);
}

function pop() {
    return stack.pop();
}

function length() {
    return stack.length;
}

function top() {
    return stack[0];
}

function bottom() {
    return stack[stack.length-1];
}
