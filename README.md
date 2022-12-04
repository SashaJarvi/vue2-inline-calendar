# Vue2 Inline Calendar

The simple, functional inline calendar component for Vue2 (version for Vue3 is in development now) based on Intersection Observer API — just drag and scroll to get future and past dates.

## Installation

`npm i vue2-inline-calendar -S`

or

`yarn add vue2-inline-calendar`

## Usage


```
<template>
    <div id="app">
        <vue-inline-calendar @select-date="selectedDate = $event" />
    </div>
</template>

<script>
import VueInlineCalendar from 'vue2-inline-calendar'

export default {
  name: 'App',
  components: {
    VueInlineCalendar
  },
  data() {
    return {
      selectedDate: null
    }
  },
}
</script>
```

## Available props
| Prop name              | Description                                                                              | Type    | Default value |
|------------------------|------------------------------------------------------------------------------------------|---------|---------------|
| daysRange              | Number of days, which will be loaded on scroll                                           | Number  | 7             |
| itemWidth              | Width of date element (`.date-item`)                                                     | Number  | 80            |
| itemsGap               | Distance between date elements                                                           | Number  | 10            |
| locale                 | A string with a [BCP 47 language tag](https://www.techonthenet.com/js/language_tags.php) | String  | "en-US"       |
| scrollSpeed            | Speed of dates scroll                                                                    | Number  | 4             |
| disableWeekends        | Excluding weekends from selection                                                        | Boolean | false         |
| specMinDate            | The first calendar date (dates before it will not be loaded)                             | Date    | null          |
| specMaxDate            | The last calendar date (dates after it will not be loaded)                               | Date    | null          |
| disablePastDays        | Excluding dates before today's date from selection                                       | Boolean | false         |
| disableNextDays        | Excluding dates after today's date from selection                                        | Boolean | false         |
| isRange                | Setting up range mode — selection of start and end dates                                 | Boolean | false         |
| showYear               | Showing of the current year (pass `false`, if you want to hide the year)                 | Boolean | true          |
| showMonth              | Showing of the date's month (pass `false`, if you want to hide the month)                | Boolean | true          |
| showWeekday            | Showing of the date's weekend (pass `false`, if you want to hide the weekend)            | Boolean | true          |
| enableMousewheelScroll | Enabling of the calendar scrolling when using the mousewheel                             | Boolean | false         |

## Available events
| Event name         | Description                                                | Payload                                                                                                                |
|--------------------|------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| select-date        | Fires on date selection                                    | Selected date (instance of `Date` object)                                                                              |
| select-dates-range | Fires on date range selection (when `endDate` is selected) | Object with startDate and endDate keys and dates as values: <br/>`{startDate: this.startDate, endDate: this.endDate }` |

## License
[MIT](https://github.com/SashaJarvi/vue2-inline-calendar/blob/main/LICENSE) License
