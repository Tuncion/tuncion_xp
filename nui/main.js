const duration = 4000;
let id = 0;
window.addEventListener('message', async (event) => {
    const item = event.data;

    if (item.type === "addXP") {
        const change = item.change;
        const currID = ++id;
        XPSound();
        $('.textContainer').append(`<p id="notify-${currID}" class="textInfo"><span class="green">+</span> YOU GAINED <span class="green">${change}XP</span></p>`);
        setTimeout(async () => $(`#notify-${currID}`).fadeOut(350), duration);
        setTimeout(async () => $(`#notify-${currID}`).remove(), duration + 350);
    }

    if (item.type === "removeXP") {
        const change = item.change;
        const currID = ++id;
        XPSound();
        $('.textContainer').append(`<p id="notify-${currID}" class="textInfo"><span class="red">-</span> YOU LOSE <span class="red">${change}XP</span></p>`);
        setTimeout(async () => $(`#notify-${currID}`).fadeOut(350), duration);
        setTimeout(async () => $(`#notify-${currID}`).remove(), duration + 350);
    }

    if (item.type === "newRank") {
        const change = item.change;
        const currID = ++id;
        LevelUPSound();
        $('.textContainer').append(`<p id="notify-${currID}" class="textInfo"><span class="yellow">▲</span> YOU REACHED <span class="yellow">LEVEL ${change}</span></p>`);
        setTimeout(async () => $(`#notify-${currID}`).fadeOut(350), duration);
        setTimeout(async () => $(`#notify-${currID}`).remove(), duration + 350);
    }

});

function XPSound() {
    let soundeffect = document.getElementById("xp_sound");
    soundeffect.volume = 0.05;
    soundeffect.load();

    setTimeout(async () => {
        soundeffect.play()
    }, 0)
}

function LevelUPSound() {
    let soundeffect = document.getElementById("level_up");
    soundeffect.volume = 0.05;
    soundeffect.load();

    setTimeout(async () => {
        soundeffect.play()
    }, 0)
}