import 'package:multi_image_picker/multi_image_picker.dart';

const REDEMPTION_UPDATE_TIME = 'redemption_update_time';
const WEB_LOGIN_TOKEN = 'web_login_token';
const STOKEN = 'stoken';
const COOKIE_STOKEN = 'cookie_stoken';
const LTOKEN = 'ltoken';
const UID = 'uid';
const IS_PURCHASE = 'is_purchase';
const SPLASH_MODE = 'splash_mode';
const NOTIFICATION_DEDEMPTION_ID = '1';
const NOTIFICATION_TIMING_TASK = '2';
const IS_INIT_APP = 'is_init_app';
const SEARCH_HISTORY = 'search_history';
const TIMING_TASK_TIME = 'timing_task_time';

const NO_SIGNNATURE_STRING = '暂无签名, 大威天龙...';
const NO_LABEL_STRING = '路人甲';

/// serve
const TENCENT_IM_APPID = '1400293398';
// const TENCENT_IM_IDENTIFIER = 'liver_im_storage';

const UMENG_APP_KEY = '5e909229978eea0718fb6daa';

const BMOB_HOST = 'https://api2.bmob.cn';
const BMOB_APP_ID = 'ca7cbfec6a9489e200783a641ef4b05a';
const BMOB_API_KEY = '0dc3762d8599ab3574f17ac48d1784d0';
const BMOB_MASTER_KEY = 'ffd6b3ff8d17574182c1aabfdb39db96';

const SPLASH_MODE_1 = '女武神';
const SPLASH_MODE_2 = '社区';
const SPLASH_MODE_3 = '无';

const WORKER_MISSION_TAG = 'missions';
const WORKER_MISSION_NAME = 'complish_missions';

const imagePickerSetting = MaterialOptions(
  selectionLimitReachedText: '最多选取九张图片',
  selectCircleStrokeColor: '#90caf9',
  actionBarColor: '#90caf9',
  actionBarTitleColor: '#ffffff',
  statusBarColor: '#90caf9',
  actionBarTitle: '选取图片',
  textOnNothingSelected: '请选择图片',
  useDetailsView: true,
  allViewTitle: '全部',
);

const String injectRaidersScript =
    'var count = 6;var interval = setInterval(() => {const appGuide = document.querySelector(".app-guide");const mhyHeader = document.querySelector(".mhy-header");const mhyScrollTab = document.querySelector(".mhy-scroll-tab.home-scroll-tab");const guideArticleHeader = document.querySelector(".guide-article-header.no-margin");const refreshLayer = document.querySelector(".pull-to-refresh-layer");const mainPage = document.querySelector(".mhy-main-page.root-page");if (!!appGuide) {appGuide.style.display = "none";count--;}if (!!mhyHeader) {mhyHeader.style.display = "none";count--;}if (!!mhyScrollTab) {mhyScrollTab.style.display = "none";count--;}if (!!guideArticleHeader) {guideArticleHeader.style.display = "none";count--;}if (!!refreshLayer) {refreshLayer.style.display = "none";count--;}if (!!mainPage) {mainPage.style.top = "0px";count--;}if (count <= 0) {clearInterval(interval);}setTimeout(() => {clearInterval(interval);}, 4500);});';

const String coverbgPath = 'assets/images/background1.jpg';
const String ysLogoPath = 'assets/images/ys_logo.png';
const String bhLogoPath = 'assets/images/bh_logo.png';
const String logoPath = 'assets/images/ic_launcher_round.png';
const String emptyPath = 'assets/images/empty.png';
const String empty1Path =
    'https://uploadstatic.mihoyo.com/contentweb/20190926/2019092620221171013.png';
