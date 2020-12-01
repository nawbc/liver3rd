class WebViewUtils {
  static String videoIframe(String url) =>
      '<style>iframe{width: 100%;height: 95%;border-radius:20px;}</style> <iframe border="0" frameborder="0" framespacing="0" scrolling="no" src="$url"></iframe>';
  static String loginObserver =
      'var r = document.querySelector(".root-page");const observer = new MutationObserver(function (mutationsList, observer) {for (let mutation of mutationsList) {if (mutation.type === "attributes" && r.classList.contains("mhy-main-page")) { Login.postMessage("login"); }}});observer.observe(r, { attributes: true, attributeFilter: ["class"] });';
}
