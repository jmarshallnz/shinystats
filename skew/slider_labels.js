$(document).ready(function() {
  /**
    Custom slider labels
  **/

  function returnLabels(value) {
    if (Math.abs(value) < 1.5) {
      return "None";
    } else if (Math.abs(value) > 4) {
        return (value > 0 ? "Right" : "Left");
    } else {
      return (value > 0 ? "Slight right" : "Slight left");
    }
  }

  var someID = $("#skew").ionRangeSlider({
    prettify: returnLabels,
    force_edges: true,
    grid: false
  });
});
