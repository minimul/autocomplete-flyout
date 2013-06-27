
## Autocomplete-flyout widget

![using-the-flyout](https://github.com/minimul/autocomplete-flyout/raw/master/img/using-the-flyout.png)

![using-autocomplete](https://github.com/minimul/autocomplete-flyout/raw/master/img/using-autocomplete.png)

For complex use cases with large datasets in where autocomplete support is desired but also being able to browse the available options via a dropdown button.

Technically, the widget leverages jqueryui (1.8.x) [autocomplete](http://api.jqueryui.com/1.8/autocomplete/) and [button](http://api.jqueryui.com/1.8/button/) as well as this fork of [jQuery-Menu](https://github.com/minimul/jQuery-Menu).

### Getting started
It is best to merely look at the [example source code](https://github.com/minimul/autocomplete-flyout/raw/master/examples/index.html) to get up and running quickly.

### Minimal usage
Basic requirements are the dom selection and a valid [jqueryui autocomplete data source](http://api.jqueryui.com/1.8/autocomplete/#option-source) with categories defined. See [demo example](https://github.com/minimul/autocomplete-flyout/raw/master/examples/data.set.js) for a starting point.
```
new AutocompleteFlyout('#transaction-chart', dataSrc);
```

### Advanced usage with options

```
new AutocompleteFlyout('#transaction-chart', dataSrc, { width: 300, maxHeight: 100 });

```

### Options
Option                 |  Description  | Default
-----------------------|----------- | -----------------
flyoutWidth            | The width of the second level flyout (must be in px e.g. 300px) | null
width                  | The width of the first-level flyout  | 180
maxHeight              | Max height of flyout | 180
shiftFlyoutFromTop     | Shift the default top start of the flyout | 0
onChoosen              | Callback fired when choosing an item | See below for default
offsetX                | Shift flyout on x-axis | 0
offsetY                | Shift flyout on y-axis | 0
menuName               | Is for fgMenu. If multiple flyouts are being used this must be unique for each one | hierarchy


### Overriding onChoosen
Below is the default callback function assigned to ```onChoosen```. It simply inserts the selected item into the input field. You can use this example to make a custom solution for your own particular needs.

```

    @options.onChoosen ||=  (item, menu, caller) =>
                              # Don't set if a category has been clicked
                              unless item.hasClass('category')
                                caller.prev().val item.text()
                                menu.kill()

```

