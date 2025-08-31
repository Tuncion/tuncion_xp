// 📂 Create release folder and copy all files
// 📝 By: ! Tuncion#0809
// 📝 Version: 1.0.0
// 📝 Date: 27.08.2023

const fs = require("fs");
const fsExtra = require(`fs-extra`);

(async () => {
    const RepositoryName = process.env.REPOSITORY_NAME;
    const ReleaseTypes = [`${RepositoryName}`];

    ReleaseTypes.forEach(async (ReleaseFolder) => {
        // Create release folder if it doesn't exist
        if (!fs.existsSync(`./release/${ReleaseFolder}/`)) fs.mkdirSync(`./release/${ReleaseFolder}/`, { recursive: true });

        // Copy all files in temp folder
        fs.readdir(`./`, (err, files) => {
            files.forEach(file => {
                if (file == "release") return; // Skip release folder
                const FilePath = "./" + file;
                const ObjectInfo = fs.statSync(FilePath);

                // if File
                if (ObjectInfo.isFile()) {
                    fs.copyFileSync(FilePath, `./release/${ReleaseFolder}/${file}`)
                };

                // if Directory
                if (ObjectInfo.isDirectory()) {
                    fs.cpSync(FilePath, `./release/${ReleaseFolder}/${file}`, { recursive: true });
                };
            });
        });
    });
})();