# Vue2 Inline Calendar

The simple, functional inline calendar component for Vue2 (you can find the version for Vue3 [here](https://github.com/SashaJarvi/vue-inline-calendar)) based on Intersection Observer API — just drag and scroll to get future and past dates.

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
| initialDate            | Initial selected date                                                                    | Date    | null          |
| initialRange           | Initial selected range of dates                                                          | Date    | null          |
| daysRange              | Number of days, which will be loaded on scroll                                           | Number  | 7             |
| itemWidth              | Width of date element (`.date-item`)                                                     | Number  | 80            |
| itemsGap               | Distance between date elements                                                           | Number  | 10            |
| locale                 | A string with a [BCP 47 language tag](https://www.techonthenet.com/js/language_tags.php) | String  | "en-US"       |
| scrollSpeed            | Speed of dates scroll                                                                    | Number  | 4             |
| disableWeekends        | Excluding weekends from selection                                                        | Boolean | false         |
| specMinDate            | Minimum allowed date                                                                     | Date    | null          |
| specMaxDate            | Maximum allowed date                                                                     | Date    | null          |
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

## Support the author
If you would like to support me and my work, you can make a donation via Buy Me a Coffee (link at the section Sponsor this project) or with cryptocurrency:

|           Platform           |                    Address                    |
|:----------------------------:|:---------------------------------------------:|
|           Bitcoin            | `bc1q0rygfalnctew4cla3ed9wfw2pv0uh4r0eyfuag`  |
| Ethereum/Tether USDT (TRC20) | `0x38b3822213c6BDCc01eF770442F5BF0842AB740f`  |
|           Litecoin           | `ltc1qdgs0jult63k6ggjzaedh3er2z7w70aktl5j2wu` |
