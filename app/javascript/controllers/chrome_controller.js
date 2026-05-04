import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.hideBoot()
    this.bindScrollState()
    this.bindSmoothScroll()
    this.bindThemeToggle()
    this.bindMobileMenu()
    this.revealSections()
  }

  hideBoot() {
    const boot = document.getElementById("boot")
    window.setTimeout(() => {
      if (!boot) return
      boot.classList.add("gone")
      window.setTimeout(() => boot.remove(), 600)
    }, 800)
  }

  bindScrollState() {
    const nav = document.querySelector("[data-nav]")
    const setScrolled = () => nav?.classList.toggle("is-scrolled", window.scrollY > 24)
    setScrolled()
    window.addEventListener("scroll", setScrolled, { passive: true })
  }

  bindSmoothScroll() {
    document.querySelectorAll("[data-scroll]").forEach((link) => {
      link.addEventListener("click", (event) => {
        const hash = link.getAttribute("href")
        if (!hash || !hash.startsWith("#")) return

        event.preventDefault()
        document.querySelector("[data-menu]")?.classList.remove("is-open")

        const target = document.querySelector(hash)
        if (target) window.scrollTo({ top: target.offsetTop - 70, behavior: "smooth" })
      })
    })
  }

  bindThemeToggle() {
    const button = document.querySelector("[data-theme-toggle]")
    button?.addEventListener("click", () => {
      const nextTheme = document.body.dataset.theme === "dark" ? "light" : "dark"
      document.body.dataset.theme = nextTheme
      button.textContent = nextTheme === "dark" ? "☼" : "☾"
    })
  }

  bindMobileMenu() {
    const menu = document.querySelector("[data-menu]")
    document.querySelector("[data-menu-open]")?.addEventListener("click", () => menu?.classList.add("is-open"))
    document.querySelector("[data-menu-close]")?.addEventListener("click", () => menu?.classList.remove("is-open"))
  }

  revealSections() {
    if (!("IntersectionObserver" in window)) {
      document.querySelectorAll(".reveal").forEach((element) => element.classList.add("in"))
      return
    }

    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return

        entry.target.classList.add("in")
        observer.unobserve(entry.target)
      })
    }, { threshold: 0, rootMargin: "0px 0px -8% 0px" })

    document.querySelectorAll(".reveal").forEach((element) => observer.observe(element))
  }
}
