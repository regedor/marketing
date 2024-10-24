function initializeCalendarFilter() {
    const calendarFilterForm = document.getElementById("calendar_filter_form");
    if (calendarFilterForm) {
      calendarFilterForm.addEventListener("change", () => {
        calendarFilterForm.submit();
      });
    }
  }
  
  document.addEventListener("turbo:load", initializeCalendarFilter);
  document.addEventListener("DOMContentLoaded", initializeCalendarFilter);