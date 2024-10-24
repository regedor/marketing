document.addEventListener("DOMContentLoaded", () => {
    const calendarFilterForm = document.getElementById("calendar_filter_form");
    if (calendarFilterForm) {
      calendarFilterForm.addEventListener("change", () => {
        calendarFilterForm.submit();
      });
    }
  });