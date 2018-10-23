// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Tabbed partials will be included in the URI (/uri/#partial/)
$(document).ready(() => {
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

  $('a[data-toggle="tab"]').on("click", function() {
    let newUrl;
    const hash = $(this).attr("href");
    newUrl = url.split("#")[0] + hash;
    newUrl += "/";
    history.replaceState(null, null, newUrl);
  });
});

// Marking the order as shipped will submit the form
$('#shipItCheckbox').change(function()
{
  if(this.checked == true)
  {
  $('#shipItForm').submit();
  }
}
