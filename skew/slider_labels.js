$(document).ready(function() {
  /**
    Custom slider labels
  **/

  function returnLabels(value) {
    if (Math.abs(value) < 2) {
      return "None";
    } else if (Math.abs(value) > 5) {
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
