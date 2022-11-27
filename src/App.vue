<template>
  <div id="app">
    <div class="container">
      <h1 class="calendar-page-title">Vue Inline Calendar Examples</h1>

      <p class="calendar-page-description">
        Drag calendar to right or left to get new dates. You can also enable mousewheel scroll by adding
        <code>enable-mousewheel-scroll</code> property.
      </p>

      <div class="calendar-wrapper">
        <p>
          You can simply select the date. <i>Selected date: {{ date }}</i>
        </p>
        <vue-inline-calendar @select-date="setDate" />
      </div>

      <div class="calendar-wrapper">
        <p>You can specify the minimal date and thereby exclude older dates from selection:</p>
        <vue-inline-calendar :spec-min-date="today" />
      </div>

      <div class="calendar-wrapper">
        <p>You can also specify the maximal date and thereby exclude newer dates from selection:</p>
        <vue-inline-calendar :spec-max-date="today" />
      </div>

      <div class="calendar-wrapper">
        <p>Finally, you can specify both minimal and maximal dates:</p>
        <vue-inline-calendar :spec-min-date="today" :spec-max-date="dayAfterWeek" />
      </div>

      <div class="calendar-wrapper">
        <p>You can exclude weekends from selection:</p>
        <vue-inline-calendar disable-weekends />
      </div>

      <div class="calendar-wrapper">
        <p>You can select the range of dates (the start and end date selection will be emitted).</p>
        <p>
          <i>Start date: {{ startDate }}</i>
        </p>
        <p>
          <i>End date: {{ endDate }}</i>
        </p>
        <vue-inline-calendar is-range @select-dates-range="setDatesRange" />
      </div>

      <div class="calendar-wrapper">
        <p>You can combine the different properties to get the desired result:</p>
        <vue-inline-calendar :spec-min-date="today" is-range disable-weekends :show-year="false" />
      </div>
    </div>
  </div>
</template>

<script>
import VueInlineCalendar from "@/components/VueInlineCalendar";

export default {
  name: "App",
  components: {
    VueInlineCalendar,
  },
  data: () => ({
    today: new Date(),
    date: null,
    startDate: null,
    endDate: null,
  }),
  computed: {
    dayAfterWeek() {
      const dateCopy = new Date(this.today.getTime());

      return new Date(dateCopy.setDate(dateCopy.getDate() + 7));
    },
  },
  methods: {
    setDate(date) {
      this.date = date;
    },
    setDatesRange({ startDate, endDate }) {
      this.startDate = startDate;
      this.endDate = endDate;
    },
  },
};
</script>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  padding: 60px 0;
}

.container {
  max-width: calc(1200px + 30px);
  margin: 0 auto;
  padding: 0 15px;
}

.calendar-page-title {
  margin-bottom: 20px;
  text-align: center;
}

.calendar-page-description {
  margin-bottom: 40px;
  text-align: center;
}

.calendar-wrapper {
  & + .calendar-wrapper {
    margin-top: 40px;
  }

  & > p {
    margin-bottom: 15px;
  }

  code {
    text-align: left;
    white-space: pre;
    word-spacing: normal;
    word-break: normal;
    word-wrap: normal;
    -moz-tab-size: 4;
    tab-size: 4;
    -moz-hyphens: none;
    hyphens: none;
  }
}
</style>
