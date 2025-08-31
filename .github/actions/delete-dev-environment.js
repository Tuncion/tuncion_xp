// 📂 Delete dev environment
// 📝 By: ! Tuncion#0809
// 📝 Version: 1.0.0
// 📝 Date: 27.08.2023

const fs = require(`fs`);
const fsExtra = require(`fs-extra`);

(async () => {
    const RepositoryName = process.env.REPOSITORY_NAME;
    const ReleaseTypes = [`${RepositoryName}`];

    ReleaseTypes.forEach(async (ReleaseFolder) => {

        // Delete .gitignore
        if (fs.existsSync(`./release/${ReleaseFolder}/.gitignore`)) await fs.unlinkSync(`./release/${ReleaseFolder}/.gitignore`);

        // Delete .git folder
        if (fs.existsSync(`./release/${ReleaseFolder}/.git`)) await fsExtra.removeSync(`./release/${ReleaseFolder}/.git`);

        // Delete .github
        if (fs.existsSync(`./release/${ReleaseFolder}/.github`)) await fsExtra.removeSync(`./release/${ReleaseFolder}/.github`);

        // Delete .vscode
        if (fs.existsSync(`./release/${ReleaseFolder}/.vscode`)) await fsExtra.removeSync(`./release/${ReleaseFolder}/.vscode`);
    });
})();