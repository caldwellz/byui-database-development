document.addEventListener('DOMContentLoaded', function () {
    var elems = document.querySelectorAll('.collapsible');
    var instances = M.Collapsible.init(elems, {
        accordion: false
    });
    setupListeners();
});

function setupListeners() {
    let headers = document.querySelectorAll('.collapsible-header');
    headers.forEach(header => {
        header.addEventListener('click', event => {
            if (header.firstElementChild.textContent.includes('right')) {
                header.firstElementChild.innerHTML = 'keyboard_arrow_down';
            } else {
                header.firstElementChild.innerHTML = 'keyboard_arrow_right';
            }
        });
    });
}