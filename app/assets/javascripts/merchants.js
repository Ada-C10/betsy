// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Tabbed partials will be included in the URI (/uri/#partial/)
$(document).ready(function() {
  let url = location.href.replace(/\/$/, "");

  if (location.hash) {
    const hash = url.split("#");
    $('#myTab a[href="#'+hash[1]+'"]').tab("show");
    url = location.href.replace(/\/#/, "#");
    history.replaceState(null, null, url);
    setTimeout(() => {
      $(window).scrollTop(0);
    }, 400);
  }
});

// // Marking the order as shipped will submit the form
// $('#shipItCheckbox').change(function()
// {
//   if(this.checked == true)
//   {
//   $('#shipItForm').submit();
//   }
// }
