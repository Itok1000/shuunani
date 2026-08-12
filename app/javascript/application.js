// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

const initDiagnosisFlow = () => {
  const form = document.getElementById("diagnosis-form")
  if (!form) return

  const progressIndicator = document.getElementById("progress-indicator")
  const steps = Array.from(form.querySelectorAll(".question-step"))
  const totalSteps = steps.length
  let currentStep = 1

  const getAnsweredCount = () => {
    return form.querySelectorAll('input[type="radio"]:checked').length
  }

  const updateProgress = () => {
    if (!progressIndicator) return
    progressIndicator.textContent = `進捗: ${getAnsweredCount()} / ${totalSteps}`
  }

  const showStep = (stepNumber) => {
    steps.forEach((step) => {
      const stepValue = Number(step.dataset.step)
      step.style.display = stepValue === stepNumber ? "block" : "none"
    })

    currentStep = stepNumber

    const currentStepElement = form.querySelector(`.question-step[data-step="${currentStep}"]`)
    const currentNextButton = currentStepElement?.querySelector(".next-btn")
    const currentResultButton = currentStepElement?.querySelector(".result-btn")
    const currentStepSelected = currentStepElement?.querySelector('input[type="radio"]:checked')

    if (currentNextButton) {
      currentNextButton.disabled = !currentStepSelected
    }

    if (currentResultButton) {
      currentResultButton.disabled = !currentStepSelected
    }

    updateProgress()
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
      const selected = step.querySelector('input[type="radio"]:checked')
      if (!selected) return

      if (currentStep < totalSteps) {
        showStep(currentStep + 1)
      }
    })

    resultButton?.addEventListener("click", () => {
      const selected = step.querySelector('input[type="radio"]:checked')
      if (!selected) return

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

  form.addEventListener("change", (event) => {
    if (event.target.matches('input[type="radio"]')) {
      const currentStepElement = form.querySelector(`.question-step[data-step="${currentStep}"]`)
      const currentNextButton = currentStepElement?.querySelector(".next-btn")
      const currentResultButton = currentStepElement?.querySelector(".result-btn")
      const hasSelection = !!currentStepElement?.querySelector('input[type="radio"]:checked')

      if (currentNextButton) currentNextButton.disabled = !hasSelection
      if (currentResultButton) currentResultButton.disabled = !hasSelection

      updateProgress()
    }
  })

  showStep(1)
}

document.addEventListener("DOMContentLoaded", initDiagnosisFlow)
document.addEventListener("turbo:load", initDiagnosisFlow)
