var count = 7;
var interval = setInterval(() => {
  const appGuide = document.querySelector(".app-guide");
  const mhyHeader = document.querySelector(".mhy-header");
  const mhyScrollTab = document.querySelector(
    ".mhy-scroll-tab.home-scroll-tab"
  );
  const guideArticleHeader = document.querySelector(
    ".guide-article-header.no-margin"
  );
  const refreshLayer = document.querySelector(".pull-to-refresh-layer");
  const mainPage = document.querySelector(".mhy-main-page.root-page");
  // const root = document.querySelector("#root");

  if (!!appGuide) {
    appGuide.style.display = "none";
    count--;
  }
  if (!!mhyHeader) {
    mhyHeader.style.display = "none";
    count--;
  }
  if (!!mhyScrollTab) {
    mhyScrollTab.style.display = "none";
    count--;
  }
  if (!!guideArticleHeader) {
    guideArticleHeader.style.display = "none";
    count--;
  }
  if (!!refreshLayer) {
    refreshLayer.style.display = "none";
    refreshLayer.style.background = "#fff";
    count--;
  }
  if (!!mainPage) {
    mainPage.style.top = "0px";
    count--;
  }

  if (count <= 0) {
    clearInterval(interval);
  }
  setTimeout(() => {
    clearInterval(interval);
  }, 4500);
});

document.querySelector(".header_wrap").style.display = "none";
document.querySelector(".valkyrie_detail_wrap").style.margin = "0";

var b = setInterval(() => { var a = document.querySelector(".player-icon.icon-widescreen"); if (!!a) { a.click(); } setTimeout(() => { clearInterval(b); }, 5000); }, 100);
