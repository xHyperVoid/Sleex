# Contributing to Sleex Desktop Environment

Thanks for your interest in contributing to Sleex! Whether you're submitting code, reporting bugs, improving documentation, or suggesting ideas - you're welcome here.

---

## What You Can Contribute

We welcome contributions in many forms:

- Code (core components, integrations, scripts, conky widgets, etc.)
- Bug reports
- Documentation improvements
- Design/UI feedback
- Feature suggestions

---

## Getting Started

### Suggestions, Feedback, or Bug Reports

If you have ideas, usability feedback, or found a bug that doesn't require you to change the code:

1. [Open an issue](https://github.com/AxOS-project/theom/issues) with a clear title and description.
2. Choose the appropriate issue template: `bug`, `feature request`, `blank issue`.
3. Include details like:
   - What you expected vs what happened
   - Steps to reproduce (if it’s a bug)
   - Screenshots (if visual)

_You don’t need to write code to be a valuable contributor._

### Code contribution

1. **[Fork](https://github.com/AxOS-project/Sleex/fork)** this repository.
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/FORK-NAME.git
   ```
3. Create a **new branch** for your contribution:
   ```bash
   git checkout -b change/your-change
   ```
4. Make your changes.
5. Commit and push:

```bash
git commit -m "explain what the commit does"
git push origin change/your-change
```

7. Open a PR (Pull request) on Sleex repository.

## Testing

Before you do make a PR (Pull request) on a code contribution, make sure that it works.

## Project overview

- `src/` folder contains the source code of Sleex.
- `src/bin` contains the binaries that Sleex require to run.
- `src/share` is where the main code and the session entry are located.
- `src/share/sleex` contains the Sleex main code.
- `src/share/wayland-session` contains the session entry that shows Sleex on the greeter.
