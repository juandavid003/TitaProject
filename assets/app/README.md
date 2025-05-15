# Google Pay Static Payment Button Assets and Layout Files

To use,

1.  Copy the drawable, layout, and values folders into your project's res folder
2.  Copy the drawable files appropriate to the language you want to use into
    your project's drawable folder
3.  link the appropriate button layout file to the layout in which it should
    appear.

For example:

```xml
    <include layout="@layout/googlepay_button"/>
    <include layout="@layout/book_with_googlepay_button"/>
    <include layout="@layout/subscribe_with_googlepay_button_no_shadow"/>
```

Google Pay payment buttons are available in three variations: dark, light, and
light with an outline.

## Brand Guidelines

For full guidelines and best practices, refer to the [Brand
Guidelines](https://developers.google.com/pay/api/android/guides/brand-guidelines)

## Resource Shrinking

We highly recommend enabling resource shrinking in your build.gradle file. For
more information, please refer to the [Shrink Your
Resources](https://developer.android.com/studio/build/shrink-code.html#shrink-resources)
section of the Android Studio documentation.
