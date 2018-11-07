(function (self) {

  //
  //
  // menu
  //
  //
  // var isMenuVisible = false;

  // var showMenu = function() {
  //   // console.log("showing menu - begin: ", isMenuVisible);
  //   $("#menu").show();
  //   $("body").addClass("disabled-scroll");
  //   isMenuVisible = true;
  //   // console.log("showing menu - end: ", isMenuVisible);
  // };

  // var hideMenu = function() {
  //   // console.log("hiding menu - begin: ", isMenuVisible);
  //   $("#menu").hide();
  //   $("body").removeClass("disabled-scroll");
  //   isMenuVisible = false;
  //   // console.log("hiding menu - end: ", isMenuVisible);
  // };

  // var toggleMenu = function() {
  //   if (isMenuVisible) {
  //     hideMenu();
  //   }
  //   else {
  //     showMenu();
  //   }
  // };




  //
  //
  // init
  //
  //
  $(document).ready(function () {
    WebFont.load({
      custom: {
        families: ['AsimovXWid', 'Asimov']
      },
      active: function() {
        $('.bigtext').bigtext();

        setTimeout(
          function() {
            $(".hidden").removeClass("hidden");
          },
          100
        );
      }
    });

    $("video.top").mousemove(function(e) {
      var h = e.pageY / $(window).height() * 100;
      var w = e.pageX / $(window).width() * 100;

      $("video.top")
        .css("-webkit-mask-position", w + "% " + h + "%")
        .css("mask-position", w + "% " + h + "%");
      console.log(e.pageX, e.pageY, w, h);
    });
    // setTimeout(
    //   function() {
    //     $('.bigtext').bigtext();
    //   },
    //   500
    // );

    // setTimeout(
    //   function() {
    //     $(".hidden").removeClass("hidden");
    //   },
    //   600
    // );


    // $(document).foundation();
    // console.log("init menu");
    // $("#menu-sign").click(function() {
    //   toggleMenu();
    // });

  });
})(this);
