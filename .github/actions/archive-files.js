// 📂 Archive release files
// 📝 By: ! Tuncion#0809
// 📝 Version: 1.0.0
// 📝 Date: 27.08.2023

const fs = require("fs");
const zipdir = require(`zip-dir`);
const fsExtra = require(`fs-extra`);

(async () => {
    const RepositoryName = process.env.REPOSITORY_NAME;
    const ReleaseTypes = [`${RepositoryName}`];

    ReleaseTypes.forEach(async (ReleaseFolder) => {

        // Create Temp Folder
        if (fs.existsSync(`./release/temp_${ReleaseFolder}/`)) await fsExtra.removeSync(`./release/temp_${ReleaseFolder}`);

        // Copy all files in temp folder
        await fs.cpSync(`./release/${ReleaseFolder}`, `./release/temp_${ReleaseFolder}/${RepositoryName}`, { recursive: true });

        // ZIP folder and save it
        const ZIPData = await zipdir(`./release/temp_${ReleaseFolder}`);
        await fs.writeFileSync(`./${ReleaseFolder}.zip`, ZIPData);
    });
})();