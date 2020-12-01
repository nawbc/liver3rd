var locker = true;
var interval = setInterval(() => {
  var r = document.querySelector(".root-page");
  if (!!r) {
    clearInterval(interval);
    const observer = new MutationObserver(function (mutationsList) {
      for (let mutation of mutationsList) {
        if (mutation.type === "attributes") {
          if (locker) {
            locker = false;
            Login.postMessage("login");
          }
        }
      }
    });
    observer.observe(r, { attributes: true, attributeFilter: ["class"] })
  }

  setTimeout(() => {
    clearInterval(interval);
  }, 4500);
}, 500);
