/*
The new 'validTags' setting is optional and allows you to specify other HTML elements that curvyCorners can attempt to round.
The value is comma separated list of html elements in lowercase.
validTags: ["div", "form"]
The above example would enable curvyCorners on FORM elements.
*/
settings = {
  tl: { radius: 20 },
  tr: { radius: 20 },
  bl: { radius: 20 },
  br: { radius: 20 },
  antiAlias: true,
  autoPad: true,
  validTags: ["div"]
}