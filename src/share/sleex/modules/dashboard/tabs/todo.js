import Widget from 'resource:///com/github/Aylur/ags/widget.js';
const { Box, Label } = Widget;
import { TodoWidget } from "../widgets/todolist.js";
import { todoTabs } from '../widgets/todo_tag.js';
import { UndoneTodoList } from '../widgets/todolist.js';
import { todoItems } from '../widgets/todolist.js';

export default () => Box({
    children: [
        UndoneTodoList(),
        todoItems(true),
    ]
})