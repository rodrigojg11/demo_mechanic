import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "serviceInput",
    "dateInput",
    "timeInput",
    "paymentInput",
    "serviceOption",
    "dateOption",
    "timeOption",
    "paymentOption",
    "slots",
    "summary",
    "submitButton"
  ]

  connect() {
    this.externalServiceLinks = document.querySelectorAll("[data-book-service]")
    this.externalServiceLinks.forEach((link) => {
      link.addEventListener("click", this.selectExternalService)
    })

    if (this.hasPaymentInputTarget && !this.paymentInputTarget.value) {
      this.paymentInputTarget.value = "pay_after_service"
    }

    this.activateCurrentValues()
    this.updateSummary()
    this.refreshAvailability()
  }

  disconnect() {
    this.externalServiceLinks?.forEach((link) => {
      link.removeEventListener("click", this.selectExternalService)
    })
  }

  selectExternalService = (event) => {
    const slug = event.currentTarget.dataset.bookService
    const option = this.serviceOptionTargets.find((item) => item.dataset.service === slug)
    if (option) this.setService(option)
  }

  selectService(event) {
    this.setService(event.currentTarget)
    this.refreshAvailability()
  }

  selectDate(event) {
    const option = event.currentTarget
    this.dateInputTarget.value = option.dataset.date
    this.setActive(this.dateOptionTargets, option)
    this.updateSummary()
    this.refreshAvailability()
  }

  selectTime(event) {
    const option = event.currentTarget
    if (option.disabled) return

    this.timeInputTarget.value = option.dataset.time
    this.setActive(this.timeOptionTargets, option)
    this.updateSummary()
  }

  selectPayment(event) {
    const option = event.currentTarget
    this.paymentInputTarget.value = option.dataset.payment
    this.setActive(this.paymentOptionTargets, option)
    this.updateSummary()
  }

  setService(option) {
    this.serviceInputTarget.value = option.dataset.service
    this.selectedServiceName = option.dataset.serviceName || option.querySelector("strong")?.textContent
    this.setActive(this.serviceOptionTargets, option)
    this.updateSummary()
  }

  activateCurrentValues() {
    this.setActiveFromValue(this.serviceOptionTargets, "service", this.serviceInputTarget?.value)
    this.setActiveFromValue(this.dateOptionTargets, "date", this.dateInputTarget?.value)
    this.setActiveFromValue(this.timeOptionTargets, "time", this.timeInputTarget?.value)
    this.setActiveFromValue(this.paymentOptionTargets, "payment", this.paymentInputTarget?.value || "pay_after_service")

    const selectedService = this.serviceOptionTargets.find((item) => item.classList.contains("is-active"))
    this.selectedServiceName = selectedService?.dataset.serviceName || selectedService?.querySelector("strong")?.textContent

    const selectedDate = this.dateOptionTargets.find((item) => item.classList.contains("is-active"))
    if (selectedDate) this.updateSaturdaySlots(selectedDate.dataset.saturday === "true")
  }

  setActiveFromValue(targets, key, value) {
    if (!value) return

    const selected = targets.find((item) => item.dataset[key] === value)
    if (selected) this.setActive(targets, selected)
  }

  setActive(targets, selected) {
    targets.forEach((target) => target.classList.toggle("is-active", target === selected))
  }

  updateSaturdaySlots(isSaturday) {
    this.refreshAvailability()
  }

  async refreshAvailability() {
    if (!this.hasSlotsTarget) return
    if (!this.serviceInputTarget?.value || !this.dateInputTarget?.value) {
      this.renderSlots([])
      return
    }

    const url = new URL(this.element.querySelector("form").dataset.availabilityUrl, window.location.origin)
    url.searchParams.set("service_slug", this.serviceInputTarget.value)
    url.searchParams.set("date", this.dateInputTarget.value)

    const response = await fetch(url, { headers: { Accept: "application/json" } })
    if (!response.ok) {
      this.renderSlots([])
      return
    }

    const payload = await response.json()
    this.renderSlots(payload.slots || [])
  }

  renderSlots(slots) {
    this.timeInputTarget.value = ""

    if (!slots.length) {
      this.slotsTarget.innerHTML = `<span class="slot-empty">No available times for this selection.</span>`
      this.updateSummary()
      return
    }

    this.slotsTarget.innerHTML = slots.map((slot) => {
      const disabled = slot.available ? "" : "disabled"
      return `<button class="slot-btn" type="button" data-booking-target="timeOption" data-time="${this.escape(slot.time)}" data-action="booking#selectTime" ${disabled}>${this.escape(slot.label)}</button>`
    }).join("")

    this.updateSummary()
  }

  updateSummary() {
    const pieces = [
      this.selectedServiceName,
      this.dateInputTarget?.value,
      this.timeInputTarget?.value,
      this.paymentInputTarget?.value === "pay_now" ? "Pay now" : "Pay after service"
    ].filter(Boolean)

    if (this.hasSummaryTarget) {
      this.summaryTarget.textContent = pieces.length ? pieces.join(" · ") : "Select service, date, and time"
    }

    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = !(
        this.serviceInputTarget?.value &&
        this.dateInputTarget?.value &&
        this.timeInputTarget?.value
      )
    }
  }

  escape(value) {
    return String(value ?? "").replace(/[&<>"']/g, (character) => ({
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      "\"": "&quot;",
      "'": "&#39;"
    }[character]))
  }
}
