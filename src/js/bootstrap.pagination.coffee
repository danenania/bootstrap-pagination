class @BootstrapPagination
  constructor: (selector, @options={})->
    @el = $(selector)
    .html("""
      <div class='pagination'>
        <ul>
          <li>
            <a class='prev' href='#'>#{options.prevText ? '«'}</a>
          </li>
          <li>
            <a class='next' href='#'>#{options.nextText ? '»'}</a>
          </li>
        </ul>
      </div>
      <div class='pagination numeric'><ul/></div>""")
    @numPages = @options.numPages
    @selectedIndex = @options.selectedIndex
    @nextBtn = @el.find('li a.next')
    @prevBtn = @el.find('li a.prev')
    @pageNums = new BootstrapPageNums @el.find('.pagination.numeric ul')
    @initListeners()
    @render(@numPages, @selectedIndex)

  initListeners: ->
    $(@pageNums).bind "pageSelect", (e, num)=>
      if num != @selectedIndex
        @render(@numPages,num)
        @_pageSelect(num)

    @nextBtn.click (e)=>
      e.preventDefault()
      if @numPages? and @selectedIndex? and @selectedIndex < @numPages - 1
        @render(@numPages, @selectedIndex+1)
        @_pageSelect(@selectedIndex)

    @prevBtn.click (e)=>
      e.preventDefault()
      if @numPages? and @selectedIndex? and @selectedIndex > 0
        @render(@numPages, @selectedIndex-1)
        @_pageSelect(@selectedIndex)

  render: (@numPages, @selectedIndex)->
    @el.toggle(@numPages? and @selectedIndex? and @numPages > 1)
    @pageNums.render(@numPages, @selectedIndex, @options.numBlocks)

  _pageSelect: (num)-> @options.onSelect?(num)


class @BootstrapPageNums
  @getPageIndex: (numPages,
                  numBlocks,
                  middleBlock,
                  lastBlock,
                  selectedIndex,
                  wasEllipsisAnterior,
                  i)->
    if i == 0
      0
    else if i == lastBlock - 1
      numPages - 1
    else if wasEllipsisAnterior
      if selectedIndex >= (numPages - middleBlock)
        if i == numBlocks - 1
          numPages - 1
        else
          (numPages - 1) - ((numBlocks - 1) - i)
      else if i == middleBlock
        selectedIndex
      else if i < middleBlock
        selectedIndex - (middleBlock - i)
      else if i > middleBlock
        selectedIndex + (i - middleBlock)
    else
      if i == selectedIndex
        i
      else if i > selectedIndex
        selectedIndex + (i - selectedIndex)
      else if i < selectedIndex
        selectedIndex - (selectedIndex - i)

  constructor: (selector, @options={})-> @el = $(selector)

  render: (numPages, selectedIndex, numBlocks=7)->
    @el.empty()
    middleBlock = Math.round((numBlocks - 1)/ 2)
    middlePage = Math.round numPages / 2
    lastBlock = Math.min(numPages,numBlocks)
    wasEllipsisAnterior = false

    for i in [0...lastBlock]
      if i > numPages - 1
        break

      ellipsisAnterior = (i == 1 and (numPages - numBlocks) >= 1 and selectedIndex > (numBlocks - (middleBlock + 1)))
      ellipsisPosterior = (i == numBlocks - 2 and (numPages - numBlocks) > 0 and selectedIndex < (numPages - (middleBlock + (numBlocks % 2) )))
      wasEllipsisAnterior = true if ellipsisAnterior

      index = BootstrapPageNums.getPageIndex(numPages,
                                             numBlocks,
                                             middleBlock,
                                             lastBlock,
                                             selectedIndex,
                                             wasEllipsisAnterior,
                                             i)

      @addBlock index, index == selectedIndex, ellipsisAnterior or ellipsisPosterior

  addBlock: (index, current=false, ellipsis=false)->
    block = $("""
      <li #{if current then "class='active'" else ""}>
        <a href='#' data-index='#{index}'>#{if ellipsis then '...' else (index + 1)}</a>
      </li>""")

    @addListeners(block)
    @el.append block

  addListeners: (block)->
    block.click (e)=>
      $(@).trigger 'pageSelect', parseInt $(e.target).data('index')
      false

