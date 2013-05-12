Bootstrap Pagination
====================

Simple client-side paging built on [bootstrap's pagination component](http://twitter.github.io/bootstrap/components.html#pagination).

    <div id="pagination"></div>

    <script>

    var pagination = new BootstrapPagination("#pagination", {
      numPages: 42,
      selectedIndex: 0,
      numBlocks: 7,
      prevText: "«",
      nextText: "»",
      onSelect: function(selectedIndex){
        //load page
      })
    });

    </script>
