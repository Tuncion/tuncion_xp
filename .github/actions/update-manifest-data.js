// 📂 Update Manifest Data
// 📝 By: ! Tuncion#0809
// 📝 Version: 1.0.0
// 📝 Date: 28.08.2023

const fs = require("fs");
const { execSync, exec } = require("child_process");

(async () => {
  const ReleaseType = process.env.RELEASE_TYPE || 'Release';
  let ManifestFile = fs.readFileSync("fxmanifest.lua", { encoding: "utf8" });

  // Patch Version
  const Patch = process.env.RELEASE_PATCH;

  ManifestFile = ManifestFile.replace(
    /\bpatch\s+(.*)$/gm,
    `patch '#${Patch}'`
  );

  // Version
  const Version = ManifestFile.match(/\bversion\s+["']?([\d.]+)["']?/)[1] || "1.0.0";
  const NewVersion = NextVersionNo(Version, ReleaseType);

  execSync(`RELEASE_VERSION=${NewVersion}\necho "RELEASE_VERSION=$RELEASE_VERSION" >> $GITHUB_ENV`);

  ManifestFile = ManifestFile.replace(
    /\bversion\s+(.*)$/gm,
    `version '${NewVersion}'`
  );

  // Released Date
  const ReleaseUser = process.env.RELEASE_USER;
  const CurrentDate = new Date();
  const options = {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    timeZone: 'Europe/Berlin', // Germany time zone
  };

  const NewReleaseDate = `${CurrentDate.toLocaleString('de-DE', options)} by ${ReleaseUser}`;

  ManifestFile = ManifestFile.replace(
    /\breleased\s+(.*)$/gm,
    `released '${NewReleaseDate}'`
  );

  // Update Fxmanifest
  fs.writeFileSync("fxmanifest.lua", ManifestFile, { encoding: "utf8" });
})();

/**
 * Increments the given version number based on the update type.
 * - "Release" updates follow the schema X.X.X.
 * - "Hotfix" updates follow the schema X.X.X.X.
 *
 * @param {string} version - The current version number.
 * @param {string} updateType - The type of update ("Release" or "Hotfix").
 * @returns {string} - The next version number.
 */
function NextVersionNo(version, updateType) {
  let parts = version.split(".").map(Number);

  if (updateType.toLowerCase() === "release") {
    // Ensure the version has 3 parts for release schema
    while (parts.length < 3) parts.push(0);
    let [major, minor, patch] = parts;
    patch++;
    if (patch > 9) {
      patch = 0;
      minor++;
    }
    if (minor > 9) {
      minor = 0;
      major++;
    }
    return `${major}.${minor}.${patch}`;
  } else if (updateType.toLowerCase() === "hotfix") {
    while (parts.length < 4) parts.push(0);
    let [major, minor, patch, hotfix] = parts;
    hotfix++;
    return `${major}.${minor}.${patch}.${hotfix}`;
  } else {
    throw new Error("Invalid update type. Use 'Release' or 'Hotfix'.");
  }
}