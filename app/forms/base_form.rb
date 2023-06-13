class BaseForm
  class DisclosureCheckNotFound < RuntimeError; end

  include Virtus.model
  include ActiveModel::Validations
  include FormAttributeMethods

  extend ActiveModel::Callbacks

  attr_accessor :disclosure_check,
                :record

  delegate :caution, :conviction, to: :disclosure_check

  # This will allow subclasses to define after_initialize callbacks
  # and is needed for some functionality to work, i.e. acts_as_gov_uk_date
  define_model_callbacks :initialize

  def initialize(*)
    run_callbacks(:initialize) { super }
  end

  # Initialize a new form object given an AR model, setting its attributes
  def self.build(record, disclosure_check: nil)
    raise "expected `ApplicationRecord`, got `#{record.class}`" unless record.is_a?(ApplicationRecord)

    attributes = attributes_map(record)

    attributes.merge!(
      disclosure_check: disclosure_check || record,
      record:,
    )

    new(attributes)
  end

  def save
    if valid?
      persist!
    else
      false
    end
  end

  def to_key
    # Intentionally returns nil so the form builder picks up _only_
    # the class name to generate the HTML attributes.
    nil
  end

  def persisted?
    false
  end

  def new_record?
    true
  end

  def conviction_subtype
    ConvictionType.find_constant(disclosure_check.conviction_subtype)
  end

private

  # :nocov:
  def record_id
    record&.id
  end
  # :nocov:

  # When using concerns like `HasOneAssociationForm` or `SingleQuestionForm`, this ensures
  # a common interface to always have the correct record being updated in the `persist!` method.
  # The default is the main model, i.e. `disclosure_check` unless overridden by subclasses.
  def record_to_persist
    disclosure_check
  end

  # :nocov:
  def persist!
    raise "Subclasses of BaseForm need to implement #persist!"
  end
  # :nocov:
end
