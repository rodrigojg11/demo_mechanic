import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.gallery = this.element.querySelector("[data-gallery]")
    this.input = this.element.querySelector("[data-upload-input]")
    this.lightbox = document.querySelector("[data-lightbox]")
    this.lightboxImage = this.lightbox?.querySelector("img")

    this.bindFilters()
    this.bindUpload()
    this.bindLightbox()
    this.element.querySelectorAll("[data-gallery-item]").forEach((tile) => this.wireTile(tile))
  }

  bindFilters() {
    this.element.querySelectorAll("[data-filter]").forEach((button) => {
      button.addEventListener("click", () => {
        this.element.querySelectorAll("[data-filter]").forEach((item) => item.classList.remove("is-active"))
        button.classList.add("is-active")

        const tag = button.dataset.filter
        this.element.querySelectorAll("[data-gallery-item]").forEach((item) => {
          item.hidden = tag !== "All" && item.dataset.tag !== tag
        })
      })
    })
  }

  bindUpload() {
    this.element.querySelector("[data-upload-tile]")?.addEventListener("click", () => this.input?.click())
    this.input?.addEventListener("change", () => {
      Array.from(this.input.files || []).forEach((file) => {
        const reader = new FileReader()
        reader.onload = (event) => {
          const fileName = this.escape(file.name)
          const tile = document.createElement("button")
          tile.type = "button"
          tile.className = "gallery-tile"
          tile.dataset.galleryItem = ""
          tile.dataset.tag = "Mine"
          tile.dataset.src = event.target.result
          tile.dataset.caption = file.name
          tile.innerHTML = `<img src="${event.target.result}" alt="${fileName}"><span>Mine</span><strong>${fileName}</strong>`
          this.gallery.insertBefore(tile, this.input.nextSibling)
          this.wireTile(tile)
        }
        reader.readAsDataURL(file)
      })
      this.input.value = ""
    })
  }

  bindLightbox() {
    this.lightbox?.querySelector("[data-lightbox-close]")?.addEventListener("click", () => {
      this.lightbox.hidden = true
    })

    this.lightbox?.addEventListener("click", (event) => {
      if (event.target === this.lightbox) this.lightbox.hidden = true
    })
  }

  wireTile(tile) {
    tile.addEventListener("click", () => {
      this.lightbox.hidden = false
      this.lightboxImage.src = tile.dataset.src
      this.lightboxImage.alt = tile.dataset.caption
      this.lightbox.querySelector("strong").textContent = tile.dataset.tag
      this.lightbox.querySelector("span").textContent = tile.dataset.caption
    })
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
