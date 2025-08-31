// 📂 Generate Changelog
// 📝 By: ! Tuncion#0809
// 📝 Version: 1.0.0
// 📝 Date: 13.12.2024

const fs = require("fs");
const { execSync } = require("child_process");

(async () => {
    const ReleaseType = process.env.RELEASE_TYPE || 'Release';
    const Changelog = [];
    const Contributors = {};

    // Get last tag when existing
    let LastTag;
    try {
        LastTag = execSync(`git describe --tags --abbrev=0 HEAD^`).toString().trim();
    } catch (err) {
        LastTag = null;
    }

    // All Commits since last tag or all commits when no tag existing
    const GitLogCommand = LastTag
        ? `git log ${LastTag}..HEAD --pretty=format:"%H|%h|%s|%an|%ae|%ad"`
        : `git log HEAD --pretty=format:"%H|%h|%s|%an|%ae|%ad"`;

    const AllCommitsSinceLastTag = [];
    const GitLogLastCommits = execSync(GitLogCommand)
        .toString()
        .trim()
        .split("\n");

    GitLogLastCommits.forEach((commit) => {
        const [hash, short_hash, message, author, email, date] = commit.split("|");
        AllCommitsSinceLastTag.push({ hash, short_hash, message, author, email, date });
        Contributors[email] = author;
    });

    // Whats's Changed
    Changelog.push(`## What's Changed`);

    const ChangedList = {};
    AllCommitsSinceLastTag.forEach((commit) => {
        let typeMatch = commit.message.match(/^(\w+)(\([^)]+\))?:/);

        if (typeMatch) {
            const type = typeMatch[1];
            if (!ChangedList[type]) ChangedList[type] = [];
            ChangedList[type].push(commit);
        } else {
            if (!ChangedList.general) ChangedList.general = [];
            ChangedList.general.push(commit);
        }
    });

    const GitTypeNameMapping = {
        feat: 'Features',
        docs: 'Documentation',
        perf: 'Performance Improvements',
        refactor: 'Refactoring',
        tweak: 'Tweak',
        fix: 'Bug Fixes',
        chore: 'Chores',
        revert: 'Reverts'
    };

    const ChangedListSorted = Object.entries(ChangedList).sort(
        ([a], [b]) =>
            Object.keys(GitTypeNameMapping).indexOf(a) - Object.keys(GitTypeNameMapping).indexOf(b)
    );

    for (const [key, element] of ChangedListSorted) {
        const sectionTitle = GitTypeNameMapping[key] || key.charAt(0).toUpperCase() + key.slice(1);
        Changelog.push(`### ${sectionTitle}:`);

        element.forEach((commit) => {
            if (commit.message.startsWith('chore:')) {
                Changelog.push(`- ${commit.short_hash}: ${commit.message} (🤖 Bot)`);
            } else {
                Changelog.push(`- ${commit.short_hash}: ${commit.message} (@${commit.author})`);
            }
        });
    }

    // Disclaimer
    Changelog.push(`\n## Disclaimer`);

    if (ReleaseType == 'Release') {
        Changelog.push(`This is a **🚀 New Release** that may include experimental features or enhancements. Please review the changelog for details and test thoroughly.`);
    } else {
        Changelog.push(`This is a **🚨 Hotfix Release** designed to address issues. Please update to ensure optimal performance and stability.`);
    };

    // Save to file
    fs.writeFileSync(`./changelog.md`, Changelog.join('\n'), { encoding: "utf8" });
})();