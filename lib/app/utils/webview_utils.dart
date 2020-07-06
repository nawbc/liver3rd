class WebViewUtils {
  static String videoIframe(String url) =>
      '<style>iframe{width: 100%;height: 95%;border-radius:20px;}</style> <iframe border="0" frameborder="0" framespacing="0" scrolling="no" src="$url"></iframe>';

  // static String removeBrTag(String data) {
  //   return data.replaceAll(RegExp(r"<br>"), '<p></p>');
  // }

  // static String customCss = "<style><style>";
}
