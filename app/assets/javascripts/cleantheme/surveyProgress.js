/* Thanks to code from @andsens
https://medium.com/@andsens/radial-progress-indicator-using-css-a917b80c43f9
*/

var transform_styles = ['-webkit-transform', '-ms-transform', 'transform'];
var progress_circles = ['#progressCircle1', '#progressCircle2', '#progressCircle3'];

function surveyProgress(rot) {
  for(p in progress_circles) {
    var rotation = (Math.floor(rot[p])/100)*180;
    var fill_rotation = rotation;
    var fix_rotation = rotation*2;
    for(i in transform_styles) {
      $('.circle'+progress_circles[p]+' .fill').css(transform_styles[i], 'rotate(' + fill_rotation + 'deg)');
      $('.circle'+progress_circles[p]+' .mask.left').css(transform_styles[i], 'rotate(' + fill_rotation + 'deg)');
      $('.circle'+progress_circles[p]+' .fill.fix').css(transform_styles[i], 'rotate(' + fix_rotation + 'deg)');
    }
  }
}

setTimeout(function() {
  var percentComplete = [$('#survey1').attr('data'), $('#survey2').attr('data'), $('#survey3').attr('data')];
  console.log(percentComplete)
  surveyProgress(percentComplete);
}, 200);
