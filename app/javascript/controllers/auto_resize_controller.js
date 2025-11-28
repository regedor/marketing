import { Controller } from "@hotwired/stimulus"

// Grows a textarea to fit its content while keeping the initial height as the minimum.
export default class extends Controller {
  static values = { minHeight: Number }

  connect() {
    this.baseHeight = this.hasMinHeightValue
      ? this.minHeightValue
      : parseFloat(getComputedStyle(this.element).height) || this.element.scrollHeight

    this.element.style.overflow = "hidden"
    this.element.style.minHeight = `${this.baseHeight}px`
    this.resize()
  }

  resize() {
    this.element.style.height = "auto"
    const targetHeight = Math.max(this.baseHeight, this.element.scrollHeight)
    this.element.style.height = `${targetHeight}px`
  }
}
