import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import { MaterialIcon } from "../.commonwidgets/materialicon.js";
import { setupCursorHover } from "../.widgetutils/cursorhover.js";
const { execAsync } = Utils;

const { Box, Label, Scrollable, Revealer, Button } = Widget;

const fetchGithubUpdates = async () => {
     try {
          const cmd = `curl -s "https://api.github.com/repos/axos-project/sleex/commits"`;
          const result = await Utils.execAsync(cmd);
          return JSON.parse(result);
     } catch (error) {
          return null;
     }
};

const isToday = (date) => {
     const today = new Date();
     return (
          date.getDate() === today.getDate() &&
          date.getMonth() === today.getMonth() &&
          date.getFullYear() === today.getFullYear()
     );
};

const CommitBox = ({ message, author, date }) => {
     const commitDate = new Date(date);
     const [title, ...description] = message
          .split("\n")
          .filter((line) => line.trim() !== "");

     return Box({
          className: "sidebar-commit-box",
          children: [
               Box({
                    className: "sidebar-chat-message-box",
                    children: [
                         Box({
                              vertical: true,
                              children: [
                                   Box({
                                        children: [
                                             MaterialIcon("commit", "norm"),
                                             Label({
                                                  xalign: 0,
                                                  className:
                                                       "sidebar-chat-name sidebar-chat-name-bot txt-bold",
                                                  label: author,
                                             }),
                                             Box({ hexpand: true }),
                                             Label({
                                                  xalign: 1,
                                                  className: isToday(commitDate)
                                                       ? "sidebar-chat-name sidebar-chat-name-bot txt-smaller txt-bold"
                                                       : "sidebar-chat-name txt-smaller txt-bold",
                                                  label: commitDate.toLocaleDateString(),
                                             }),
                                        ],
                                   }),
                                   Label({
                                        xalign: 0,
                                        className: "txt-smaller txt-bold",
                                        css: "color: white;",
                                        label: title,
                                        wrap: true,
                                   }),
                                   description.length > 0
                                        ? Label({
                                               xalign: 0,
                                               className: "txt-smaller",
                                               css: "color: white;",
                                               label: description.join("\n"),
                                               wrap: true,
                                          })
                                        : null,
                              ],
                         }),
                    ],
               }),
          ],
     });
};

const TodayCommitsCount = (commits) => {
     const todayCommits = commits.filter((commit) =>
          isToday(new Date(commit.commit.author.date))
     ).length;

     return Box({
          className: "sidebar-module-box",
          children: [
               Label({
                    xalign: 0,
                    className:
                         "sidebar-chat-name sidebar-chat-name-bot txt-bold",
                    label: `Today: ${todayCommits} ${
                         todayCommits === 1 ? "commit" : "commits"
                    }`,
               }),
          ],
     });
};

const GithubContent = () =>
     Box({
          vertical: true,
          className: "sidebar-updates-commits-viewport",
          setup: (self) => {
               const update = async () => {
                    const commits = await fetchGithubUpdates();
                    if (!commits || !commits.length) return;

                    self.children = [
                         TodayCommitsCount(commits),
                         Box({
                              vertical: true,
                              className: "spacing-v-5",
                              children: commits.slice(0, 5).map((commit) =>
                                   CommitBox({
                                        message: commit.commit.message,
                                        author: commit.commit.author.name,
                                        date: commit.commit.author.date,
                                   })
                              ),
                         }),
                    ];
               };
               update();
               Utils.timeout(1000 * 60 * 120, update);
          },
     });

const UpdateBox = () => {
     const currentVersion = Utils.exec("pacman -Q sleex");
     const newVersion = Utils.exec("pacman -Qu sleex");
     const isNewVersionAvailable = currentVersion < newVersion ? true : false;
     return Box({
          className: "sidebar-commit-box",
          vertical: true,
          children: [
               MaterialIcon("update", "norm"),
               Label({
                    className: "txt-bold",
                    label: `Current version: ${currentVersion}`,
               }),
               Box({ hexpand: true }),
               Label({
                    className:
                         "sidebar-chat-name sidebar-chat-name-bot txt-smaller txt-bold",
                    label: isNewVersionAvailable
                         ? `New version available: ${newVersion}`
                         : "No updates available",
               }),
               Revealer({
                    revealChild: true,
                    transition: "slide_down",
                    transitionDuration: userOptions.animations.durationLarge,
                    className: "sidebar-chat-name txt-smaller txt-bold",
                    child: Button({
                         className: "btn-update",
                         label: "Update",
                         setup: setupCursorHover,
                         onClicked: () => {
                              execAsync(
                                   "foot -e sudo pacman -Sy sleex axskel-hypr"
                              );
                         },
                    }),
                    setup: (self) => {
                         self.reveal_child = isNewVersionAvailable;
                    },
               }),
          ],
     });
};

const UpdateWidget = () =>
     Box({
          vertical: true,
          className: "",
          children: [
               // Label({
               //   className: "txt-bold",
               //   label: "The update section shows the latest updates of Sleex.",
               // }),
               UpdateBox(),
          ],
     });

export default Box({
     vertical: true,
     children: [UpdateWidget(), GithubContent()],
});
