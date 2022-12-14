<template>
  <div class="inline-calendar">
    <ul
      v-dragscroll.x
      @dragscrollmove="disableDateSelection"
      @dragscrollend="enableDateSelection"
      ref="datesWrapper"
      class="inline-calendar__dates"
      :style="dateItemsStyles"
    >
      <the-observer
        v-if="showFirstObserver"
        class="inline-calendar__date date-item"
        @intersect="getPrevDatesInRange(minDate, daysRange, true)"
        :options="prevObserverOptions"
      />
      <li
        v-for="(date, index) in datesReadable"
        :key="`date-item_${index}`"
        class="inline-calendar__date date-item"
        :class="{
          'in-range': date.isInRange,
          today: date.isToday,
          disabled: date.isDisabled,
          active: date.isActive,
        }"
        @click.stop="dateClickHandler(date.date)"
      >
        <p v-if="showYear" class="date-item__year">{{ date.year }}</p>

        <p v-if="showMonth" class="date-item__month">{{ date.month }}</p>

        <h2 class="date-item__day">{{ date.day }}</h2>

        <p v-if="showWeekday" class="date-item__weekday">{{ date.weekday }}</p>
      </li>
      <the-observer
        v-if="showLastObserver"
        class="inline-calendar__date date-item"
        @intersect="getNextDatesInRange(maxDate, daysRange, true)"
        :options="nextObserverOptions"
      />
    </ul>
  </div>
</template>

<script>
import { dragscroll } from "vue-dragscroll";
import checkSameDay from "@/helpers/check-same-day";
import checkIsWeekend from "@/helpers/check-is-weekend";
import checkIsInRange from "@/helpers/check-is-in-range";
import TheObserver from "@/components/TheObserver";

export default {
  name: "VueInlineCalendar",
  components: {
    TheObserver,
  },
  directives: {
    dragscroll,
  },
  props: {
    initialDate: {
      type: Date,
      default: null,
    },
    initialRange: {
      type: Object,
      default: null,
      validator: value => {
        return (
          Object.prototype.hasOwnProperty.call(value, "startDate") &&
          Object.prototype.hasOwnProperty.call(value, "endDate") &&
          value.startDate instanceof Date &&
          value.endDate instanceof Date
        );
      },
    },
    daysRange: {
      type: Number,
      default: 7,
    },
    itemWidth: {
      type: Number,
      default: 80,
    },
    itemsGap: {
      type: Number,
      default: 10,
    },
    locale: {
      type: String,
      default: "en-US",
    },
    scrollSpeed: {
      type: Number,
      default: 4,
    },
    disableWeekends: {
      type: Boolean,
      default: false,
    },
    specMinDate: {
      type: Date,
      default: null,
    },
    specMaxDate: {
      type: Date,
      default: null,
    },
    disablePastDays: {
      type: Boolean,
      default: false,
    },
    disableNextDays: {
      type: Boolean,
      default: false,
    },
    isRange: {
      type: Boolean,
      default: false,
    },
    showYear: {
      type: Boolean,
      default: true,
    },
    showMonth: {
      type: Boolean,
      default: true,
    },
    showWeekday: {
      type: Boolean,
      default: true,
    },
    enableMousewheelScroll: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      dates: [],
      canSelectDate: true,
      selectedDate: this.initialDate,
      minDate: null,
      maxDate: null,
      startDate: this.initialRange?.startDate || null,
      endDate: this.initialRange?.endDate || null,
      showFirstObserver: true,
      showLastObserver: true,
      windowWidth: window.innerWidth,
    };
  },
  mounted() {
    // adding calendar scroll on mousewheel
    const datesWrapperEl = this.$refs.datesWrapper;

    if (this.enableMousewheelScroll) {
      datesWrapperEl.addEventListener("wheel", e => {
        e.preventDefault();

        datesWrapperEl.scrollBy({
          left: (e.deltaY < 0 ? -this.itemWidth : this.itemWidth) * this.scrollSpeed,
          behavior: "smooth",
        });
      });
    }

    window.addEventListener("resize", this.onResize);

    // getting initial list of dates
    this.fillCalendar();

    // select today's date as initial
    this.$nextTick(() => {
      const todayItem = this.$el.querySelector(".date-item.today");
      todayItem.scrollIntoView({
        inline: "start",
      });
    });
  },
  watch: {
    $props: {
      immediate: true,
      handler() {
        this.validateMinMaxDates();
        this.validateInitialValues();
      },
    },
    windowWidth: {
      handler(newVal, oldVal) {
        if (oldVal > newVal) {
          return;
        }

        this.fillCalendar();
      },
    },
  },
  computed: {
    datesReadable() {
      return this.dates.map(date => {
        return {
          date,
          month: new Date(date).toLocaleDateString(this.locale, {
            month: "short",
          }),
          year: new Date(date).getFullYear(),
          weekday: new Date(date).toLocaleDateString(this.locale, {
            weekday: "short",
          }),
          day: new Date(date).getDate(),
          isToday: checkSameDay(date, new Date()),
          isWeekend: checkIsWeekend(new Date(date)),
          isActive:
            (this.selectedDate && checkSameDay(date, this.selectedDate)) ||
            (this.startDate && checkSameDay(date, this.startDate)) ||
            (this.endDate && checkSameDay(date, this.endDate)),
          ...(this.isRange && { isInRange: checkIsInRange(date, this.startDate, this.endDate) }),
          isDisabled:
            (this.disableWeekends && checkIsWeekend(new Date(date))) ||
            (this.disablePastDays && date < new Date()) ||
            (this.disableNextDays && date > new Date()),
        };
      });
    },
    dateItemsStyles() {
      return {
        gridAutoColumns: `${this.itemWidth}px`,
        gridColumnGap: `${this.itemsGap}px`,
      };
    },
    prevObserverOptions() {
      return {
        threshold: 0,
        root: this.$refs.datesWrapper,
        rootMargin: `0px 0px 0px ${this.itemWidth}px`,
      };
    },
    nextObserverOptions() {
      return {
        threshold: 0,
        root: this.$refs.datesWrapper,
        rootMargin: `0px ${this.itemWidth}px 0px 0px`,
      };
    },
  },
  methods: {
    fillCalendar() {
      if (this.dates.length) {
        this.dates = [];
      }

      const rangeInitial = Math.ceil(this.windowWidth / ((this.itemWidth - this.itemsGap) * 2));
      this.getNextDatesInRange(new Date(), rangeInitial, false);
      this.getPrevDatesInRange(new Date(), rangeInitial, true);
    },
    getPrevDatesInRange(startDate, days, excludeFirstDate = false) {
      const date = new Date(startDate.getTime());

      if (excludeFirstDate) {
        date.setDate(date.getDate() - 1);
      }

      const dateCopy = new Date(date.getTime());
      let beginningDate = new Date(dateCopy.setDate(dateCopy.getDate() - days));

      let dates = [];

      while (date > beginningDate) {
        dates.unshift(new Date(date));
        date.setDate(date.getDate() - 1);

        if (this.specMinDate) {
          dates = dates.filter(d => d > this.specMinDate || checkSameDay(d, this.specMinDate));
          this.showFirstObserver = dates.length >= days;
        }
      }

      this.dates = this.dates.length ? [...dates, ...this.dates] : dates;

      this.minDate = this.dates[0];

      // keeping scroll position on adding elements to the beginning of the list
      const datesWrapperEl = this.$refs.datesWrapper;
      const currScrollPos = datesWrapperEl.scrollLeft;
      const oldScroll = datesWrapperEl.scrollWidth - datesWrapperEl.clientWidth;

      this.$nextTick(() => {
        const newScroll = datesWrapperEl.scrollWidth - datesWrapperEl.clientWidth;
        datesWrapperEl.scrollLeft = currScrollPos + (newScroll - oldScroll);
      });
    },
    getNextDatesInRange(startDate, days, excludeFirstDate = false) {
      const date = new Date(startDate.getTime());

      if (excludeFirstDate) {
        date.setDate(date.getDate() + 1);
      }

      const dateCopy = new Date(date.getTime());
      const endDate = new Date(dateCopy.setDate(dateCopy.getDate() + days));

      let dates = [];

      while (date < endDate) {
        dates.push(new Date(date));
        date.setDate(date.getDate() + 1);

        if (this.specMaxDate) {
          dates = dates.filter(d => d < this.specMaxDate || checkSameDay(d, this.specMaxDate));
          this.showLastObserver = dates.length >= days;
        }
      }

      this.dates = this.dates.length ? [...this.dates, ...dates] : dates;
      this.maxDate = this.dates[this.dates.length - 1];
    },
    dateClickHandler(date) {
      if (this.isRange) {
        this.startDate ? this.setEndDate(date) : this.setStartDate(date);
        return;
      }

      this.setActiveDate(date);
    },
    setActiveDate(date) {
      if (!this.canSelectDate) {
        return false;
      }

      this.selectedDate = date;
      this.$emit("select-date", date);
    },
    setStartDate(date) {
      if (!this.canSelectDate) {
        return false;
      }

      this.startDate = date;
    },
    setEndDate(date) {
      if (!this.canSelectDate) {
        return;
      }

      if (this.startDate === date || this.endDate === date) {
        this.startDate = date;
        this.endDate = null;
        return;
      }

      this.endDate = date;

      if (this.startDate > this.endDate) {
        [this.startDate, this.endDate] = [this.endDate, this.startDate];
      }

      this.$emit("select-dates-range", { startDate: this.startDate, endDate: this.endDate });
    },
    enableDateSelection() {
      setTimeout(() => {
        this.canSelectDate = true;
      }, 0);
    },
    disableDateSelection(e) {
      if (e.detail.deltaX === -1 || Object.is(e.detail.deltaX, -0)) {
        return;
      }

      this.canSelectDate = false;
    },
    onResize() {
      this.windowWidth = window.innerWidth;
    },
    validateMinMaxDates() {
      if (this.minDate > this.maxDate) {
        console.error("minDate cannot be greater than maxDate");
      }

      return true;
    },
    validateInitialValues() {
      if (this.isRange && this.selectedDate) {
        console.error("You should use initialRange property with isRange");
        return;
      }

      if (!this.isRange && this.startDate && this.endDate) {
        console.error("You should use initialDate property with default mode");
      }
    },
  },
  beforeDestroy() {
    if (this.enableMousewheelScroll) {
      const datesWrapperEl = this.$refs.datesWrapper;
      datesWrapperEl.replaceWith(datesWrapperEl.cloneNode(true));
    }

    window.removeEventListener("resize", this.onResize);
  },
};
</script>

<style lang="scss">
.inline-calendar {
  display: flex;
  margin-bottom: 8px;
  padding: 0 10px;

  &__dates {
    display: grid;
    grid-auto-flow: column;
    margin-left: -10px;
    margin-right: -10px;
    padding: 8px 10px;
    list-style-type: none;
    overflow-x: scroll;
    white-space: nowrap;
    -ms-overflow-style: none;
    scrollbar-width: none;

    &::-webkit-scrollbar {
      display: none;
    }
  }

  &__date {
    padding: 12px;
    text-align: center;
    background-color: #fff;
    border: 1px solid #0094ff;
    border-radius: 8px;
    cursor: pointer;
    -webkit-user-select: none;
    user-select: none;

    &.today {
      color: #fff;
      border-color: rgba(96, 112, 128, 0.8);
      background-color: rgba(96, 112, 128, 0.8);
    }

    &.in-range {
      color: #fff;
      border-color: rgba(#0094ff, 0.6) !important;
      background-color: rgba(#0094ff, 0.6) !important;
    }

    &.active {
      color: #fff;
      border-color: #0094ff !important;
      background-color: #0094ff !important;
    }

    &.disabled {
      opacity: 0.5;
      pointer-events: none;
    }
  }
}

.date-item {
  &__month,
  &__weekday {
    font-size: 12px;
    line-height: 14px;
    text-align: center;
  }

  &__month {
    margin: 0 0 8px;
  }

  &__weekday {
    font-weight: 500;
  }

  &__day {
    margin: 10px 0;
    font-weight: 600;
    font-size: 16px;
    line-height: 18px;
  }

  &__year {
    margin: 0 0 8px;
    font-size: 12px;
    font-weight: 500;
    line-height: 14px;
    text-align: right;
  }
}
</style>
