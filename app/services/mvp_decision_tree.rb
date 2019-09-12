class MvpDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :info
      show(:confirmation)
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
end
