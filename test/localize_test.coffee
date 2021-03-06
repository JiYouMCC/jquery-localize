do ($ = jQuery) ->

  localizableTagWithRel = (tag, localizeKey, attributes) ->
    t = $("<#{tag}>").attr("rel", "localize[#{localizeKey}]")
    applyTagAttributes(t, attributes)

  localizableTagWithDataLocalize = (tag, localizeKey, attributes) ->
    t = $("<#{tag}>").attr("data-localize", localizeKey)
    applyTagAttributes(t, attributes)

  applyTagAttributes = (tag, attributes) ->
    if attributes.text?
      tag.text(attributes.text)
      delete attributes.text
    if attributes.val?
      tag.val(attributes.val)
      delete attributes.val
    tag.attr(k,v) for k, v of attributes
    tag

  module "Basic Usage"

  setup ->
    @testOpts = language: "ja", pathPrefix: "lang"

  test "basic tag text substitution", ->
    t = localizableTagWithRel("p", "basic", text: "basic fail")
    t.localize("test", @testOpts)
    equal t.text(), "basic success"

  test "basic tag text substitution using data-localize instead of rel", ->
    t = localizableTagWithDataLocalize("p", "basic", text: "basic fail")
    t.localize("test", @testOpts)
    equal t.text(), "basic success"

  test "basic tag text substitution with nested key", ->
    t = localizableTagWithRel("p", "test.nested", text: "nested fail")
    t.localize("test", @testOpts)
    equal t.text(), "nested success"

  test "basic tag text substitution for special title key", ->
    t = localizableTagWithDataLocalize("p", "with_title", text: "with_title element fail", title: "with_title title fail")
    t.localize("test", @testOpts)
    equal t.text(), "with_title text success"
    equal t.attr("title"), "with_title title success"

  test "input tag value substitution", ->
    t = localizableTagWithRel("input", "test.input", val: "input fail")
    t.localize("test", @testOpts)
    equal t.val(), "input success"

  test "input tag value after second localization without key", ->
    t = localizableTagWithRel("input", "test.input", val: "input fail")
    t.localize("test", @testOpts)
    t.localize("test2", @testOpts)
    equal t.val(), "input success"

  test "input tag placeholder substitution", ->
    t = localizableTagWithRel("input", "test.input", placeholder: "placeholder fail")
    t.localize("test", @testOpts)
    equal t.attr("placeholder"), "input success"

  test "textarea tag placeholder substitution", ->
    t = localizableTagWithRel("textarea", "test.input", placeholder: "placeholder fail")
    t.localize("test", @testOpts)
    equal t.attr("placeholder"), "input success"

  test "titled input tag value substitution", ->
    t = localizableTagWithRel("input", "test.input_as_obj", val: "input_as_obj fail")
    t.localize("test", @testOpts)
    equal t.val(), "input_as_obj value success"

  test "titled input tag title substitution", ->
    t = localizableTagWithRel("input", "test.input_as_obj", val: "input_as_obj fail")
    t.localize("test", @testOpts)
    equal t.attr("title"), "input_as_obj title success"

  test "titled input tag placeholder substitution", ->
    t = localizableTagWithRel("input", "test.input_as_obj", placeholder: "placeholder fail")
    t.localize("test", @testOpts)
    equal t.attr("placeholder"), "input_as_obj value success"

  test "image tag src, alt, and title substitution", ->
    t = localizableTagWithRel("img", "test.ruby_image", src: "ruby_square.gif", alt: "a square ruby", title: "A Square Ruby")
    t.localize("test", @testOpts)
    equal t.attr("src"), "ruby_round.gif"
    equal t.attr("alt"), "a round ruby"
    equal t.attr("title"), "A Round Ruby"

  test "link tag href substitution", ->
    t = localizableTagWithRel("a", "test.link", href: "http://fail", text: "fail")
    t.localize("test", @testOpts)
    equal t.attr("href"), "http://success"
    equal t.text(), "success"

  test "tooltips", ->
    t = localizableTagWithRel("div", "tooltip", 
      "data-toggle": "tooltip", 
      title: "basic fail", 
      "data-original-title": "basic fail",
      text: "text fail")
    opts = language: "zh", pathPrefix: "lang"
    t.localize("tooltip", opts)
    equal t.attr("title"), "title success"
    equal t.attr("data-original-title"), "data original title success"
    equal t.data("original-title"), "data original title success"
    equal t.text(), "text success"

  test "tooltips no text", ->
    t = localizableTagWithRel("div", "tooltip no text", 
      "data-toggle": "tooltip", 
      title: "basic fail", 
      "data-original-title": "basic fail",
      text: "text success")
    opts = language: "zh", pathPrefix: "lang"
    t.localize("tooltip", opts)
    equal t.attr("title"), "title success"
    equal t.attr("data-original-title"), "data original title success"
    equal t.data("original-title"), "data original title success"
    equal t.text(), "text success"

  test "not tooltips", ->
    t = localizableTagWithRel("div", "tooltip", 
      title: "title success", 
      "data-original-title": "data original title success",
      text: "text success")
    opts = language: "zh", pathPrefix: "lang"
    t.localize("not tooltip", opts)
    equal t.attr("title"), "title success"
    equal t.attr("data-original-title"), "data original title success"
    equal t.data("original-title"), "data original title success"
    equal t.text(), "text success"

  test "chained call", ->
    t = localizableTagWithRel("p", "basic", text: "basic fail")
    t.localize("test", @testOpts).localize("test", @testOpts)
    equal t.text(), "basic success"

  test "alternative file extension", ->
    t = localizableTagWithRel("p", "basic", text: "basic fail")
    t.localize("test", $.extend({ fileExtension: "foo" }, @testOpts))
    equal t.text(), "basic success foo"

  moreSetup ->
    @t = $('<select>
        <optgroup rel="localize[test.optgroup]" label="optgroup fail">
          <option rel="localize[test.option]" value="1">option fail</option>
        </optgroup>
      </select>')

  test "optgroup tag label substitution", ->
    t = @t.find("optgroup")
    t.localize("test", @testOpts)
    equal t.attr("label"), "optgroup success"

  test "option tag text substitution", ->
    t = @t.find("option")
    t.localize("test", @testOpts)
    equal t.text(), "option success"

  module "Options"

  test "fallback language loads", ->
    opts = language: "fo", fallback: "ja", pathPrefix: "lang"
    t = localizableTagWithRel("p", "basic", text: "basic fail")
    t.localize("test", opts)
    equal t.text(), "basic success"

  test "pathPrefix loads lang files from custom path", ->
    opts =  language: "fo", pathPrefix: "/test/lang/custom"
    t = localizableTagWithRel("p", "path_prefix", text: "pathPrefix fail")
    t.localize("test", opts)
    equal t.text(), "pathPrefix success"

  test "custom callback is fired", ->
    opts = language: "ja", pathPrefix: "lang"
    opts.callback = (data, defaultCallback) ->
      data.custom_callback = "custom callback success"
      defaultCallback(data)
    t = localizableTagWithRel("p", "custom_callback", text: "custom callback fail")
    t.localize("test", opts)
    equal t.text(), "custom callback success"

  test "language with country code", ->
    opts = language: "ja-XX", pathPrefix: "lang"
    t = localizableTagWithRel("p", "message", text: "country code fail")
    t.localize("test", opts)
    equal t.text(), "country code success"

  module "Language optimization"

  test "skipping language using string match", ->
    opts = language: "en", pathPrefix: "lang", skipLanguage: "en"
    t = localizableTagWithRel("p", "en_message", text: "en not loaded")
    t.localize("test", opts)
    equal t.text(), "en not loaded"

  test "skipping language using regex match", ->
    opts = language: "en-US", pathPrefix: "lang", skipLanguage: /^en/
    t = localizableTagWithRel("p", "en_us_message", text: "en-US not loaded")
    t.localize("test", opts)
    equal t.text(), "en-US not loaded"

  test "skipping language using array match", ->
    opts = language: "en", pathPrefix: "lang", skipLanguage: ["en", "en-US"]
    t = localizableTagWithRel("p", "en_message", text: "en not loaded")
    t.localize("test", opts)
    equal t.text(), "en not loaded"

    opts = language: "en-US", pathPrefix: "lang", skipLanguage: ["en", "en-US"]
    t = localizableTagWithRel("p", "en_us_message", text: "en-US not loaded")
    t.localize("test", opts)
    equal t.text(), "en-US not loaded"

  test "update data-localize and localize again", ->
    t = $('<div data-localize="string1">original string 1</div>')
    equal t.text(), "original string 1", "the original string is incorrect."
    opts = language: "zh", pathPrefix: "lang"
    t.localize("change", opts)
    equal t.text(), "string 1 success", "localize 1 fail."
    t.attr("data-localize", "string2")
    t.localize("change", opts)
    equal t.text(), "string 2 success", "localize 2 fail."

  module "Load json value"

  moreSetup ->
    @jsonData = {
      "ja":{
        "test": {
          "nested": "nested success",
          "input": "input success",
          "input_as_obj": {
              "value": "input_as_obj value success",
              "title": "input_as_obj title success"
          },
          "optgroup": "optgroup success",
          "option": "option success",
          "ruby_image": {
            "src": "ruby_round.gif",
            "alt": "a round ruby",
            "title": "A Round Ruby"
          },
          "link": {
            "text": "success",
            "href": "http://success"
          }
        },
        "basic": "basic success",
        "with_title": {
          "text": "with_title text success",
          "title": "with_title title success"
        }
      }
    }
    @jsonOpts = language: "ja"
    @jsonData2 = {
      "ja":{}
    }
    @jsonToolTip = {
      "zh":{
          "tooltip": {
              "title":"title success",
              "data-original-title": "data original title success",
              "text": "text success"
          },
          "tooltip no text": {
              "title":"title success",
              "data-original-title": "data original title success"
          },
          "not tooltip": {
              "title":"title fail",
              "data-original-title": "data original title fail",
              "text": "text fail"
          }
      }
    }

  test "Json basic tag text substitution", ->
    t = localizableTagWithRel("p", "basic", text: "basic fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.text(), "basic success"

  test "Json basic tag text substitution using data-localize instead of rel", ->
    t = localizableTagWithDataLocalize("p", "basic", text: "basic fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.text(), "basic success"

  test "Json basic tag text substitution with nested key", ->
    t = localizableTagWithRel("p", "test.nested", text: "nested fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.text(), "nested success"

  test "Json basic tag text substitution for special title key", ->
    t = localizableTagWithDataLocalize("p", "with_title", text: "with_title element fail", title: "with_title title fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.text(), "with_title text success"
    equal t.attr("title"), "with_title title success"

  test "Json input tag value substitution", ->
    t = localizableTagWithRel("input", "test.input", val: "input fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.val(), "input success"

  test "Json input tag value after second localization without key", ->
    t = localizableTagWithRel("input", "test.input", val: "input fail")
    t.localize(@jsonData, @jsonOpts)
    t.localize(@jsonData2, @jsonOpts)
    equal t.val(), "input success"

  test "Json input tag placeholder substitution", ->
    t = localizableTagWithRel("input", "test.input", placeholder: "placeholder fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.attr("placeholder"), "input success"

  test "Json textarea tag placeholder substitution", ->
    t = localizableTagWithRel("textarea", "test.input", placeholder: "placeholder fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.attr("placeholder"), "input success"

  test "Json titled input tag value substitution", ->
    t = localizableTagWithRel("input", "test.input_as_obj", val: "input_as_obj fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.val(), "input_as_obj value success"

  test "Json titled input tag title substitution", ->
    t = localizableTagWithRel("input", "test.input_as_obj", val: "input_as_obj fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.attr("title"), "input_as_obj title success"

  test "Json titled input tag placeholder substitution", ->
    t = localizableTagWithRel("input", "test.input_as_obj", placeholder: "placeholder fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.attr("placeholder"), "input_as_obj value success"

  test "Json image tag src, alt, and title substitution", ->
    t = localizableTagWithRel("img", "test.ruby_image", src: "ruby_square.gif", alt: "a square ruby", title: "A Square Ruby")
    t.localize(@jsonData, @jsonOpts)
    equal t.attr("src"), "ruby_round.gif"
    equal t.attr("alt"), "a round ruby"
    equal t.attr("title"), "A Round Ruby"

  test "Json link tag href substitution", ->
    t = localizableTagWithRel("a", "test.link", href: "http://fail", text: "fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.attr("href"), "http://success"
    equal t.text(), "success"

  test "Json tooltips", ->
    t = localizableTagWithRel("div", "tooltip", 
      "data-toggle": "tooltip", 
      title: "basic fail", 
      "data-original-title": "basic fail",
      text: "text fail")
    opts = language: "zh"
    t.localize(@jsonToolTip, opts)
    equal t.attr("title"), "title success"
    equal t.attr("data-original-title"), "data original title success"
    equal t.data("original-title"), "data original title success"
    equal t.text(), "text success"

  test "Json tooltips no text", ->
    t = localizableTagWithRel("div", "tooltip no text", 
      "data-toggle": "tooltip", 
      title: "basic fail", 
      "data-original-title": "basic fail",
      text: "text success")
    opts = language: "zh"
    t.localize(@jsonToolTip, opts)
    equal t.attr("title"), "title success"
    equal t.attr("data-original-title"), "data original title success"
    equal t.data("original-title"), "data original title success"
    equal t.text(), "text success"

  test "Json not tooltips", ->
    t = localizableTagWithRel("div", "tooltip", 
      title: "title success", 
      "data-original-title": "data original title success",
      text: "text success")
    opts = language: "zh"
    t.localize(@jsonToolTip, opts)
    equal t.attr("title"), "title success"
    equal t.attr("data-original-title"), "data original title success"
    equal t.data("original-title"), "data original title success"
    equal t.text(), "text success"

  test "Json chained call", ->
    t = localizableTagWithRel("p", "basic", text: "basic fail")
    t.localize(@jsonData, @jsonOpts).localize(@jsonData, @jsonOpts)
    equal t.text(), "basic success"

  moreSetup ->
    @t = $('<select>
        <optgroup rel="localize[test.optgroup]" label="optgroup fail">
          <option rel="localize[test.option]" value="1">option fail</option>
        </optgroup>
      </select>')

  test "Json optgroup tag label substitution", ->
    t = @t.find("optgroup")
    t.localize(@jsonData, @jsonOpts)
    equal t.attr("label"), "optgroup success"

  test "Json option tag text substitution", ->
    t = @t.find("option")
    t.localize(@jsonData, @jsonOpts)
    equal t.text(), "option success"

  test "Json fallback language loads", ->
    opts = language: "fo", fallback: "ja"
    t = localizableTagWithRel("p", "basic", text: "basic fail")
    t.localize(@jsonData, @jsonOpts)
    equal t.text(), "basic success"

  test "Json custom callback is fired", ->
    opts = language: "ja"
    opts.callback = (data, defaultCallback) ->
      data.custom_callback = "custom callback success"
      defaultCallback(data)
    t = localizableTagWithRel("p", "custom_callback", text: "custom callback fail")
    t.localize(@jsonData, opts)
    equal t.text(), "custom callback success"

  test "Json language with country code", ->
    jsonData = {
      "ja-XX":{ "message": "country code success" }
    }
    opts = language: "ja-XX"
    t = localizableTagWithRel("p", "message", text: "country code fail")
    t.localize(jsonData, opts)
    equal t.text(), "country code success"
