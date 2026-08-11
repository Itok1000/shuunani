// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

const initDiagnosisFlow = () => {
  const form = document.getElementById("diagnosis-form")
  if (!form) return

  const steps = Array.from(form.querySelectorAll(".question-step"))
  const totalSteps = steps.length
  let currentStep = 1

  const showStep = (stepNumber) => {
    steps.forEach((step) => {
      const stepValue = Number(step.dataset.step)
      step.style.display = stepValue === stepNumber ? "block" : "none"
    })

    currentStep = stepNumber
  }

  steps.forEach((step) => {
    const stepValue = Number(step.dataset.step)
    const prevButton = step.querySelector(".prev-btn")
    const nextButton = step.querySelector(".next-btn")
    const resultButton = step.querySelector(".result-btn")

    prevButton?.addEventListener("click", () => {
      if (currentStep > 1) {
        showStep(currentStep - 1)
      }
    })

    nextButton?.addEventListener("click", () => {
      if (currentStep < totalSteps) {
        showStep(currentStep + 1)
      }
    })

    resultButton?.addEventListener("click", () => {
      if (typeof form.requestSubmit === "function") {
        form.requestSubmit()
      } else {
        form.submit()
      }
    })

    if (prevButton && stepValue === 1) {
      prevButton.disabled = true
    }
  })

  showStep(1)
}

document.addEventListener("DOMContentLoaded", initDiagnosisFlow)
document.addEventListener("turbo:load", initDiagnosisFlow)
