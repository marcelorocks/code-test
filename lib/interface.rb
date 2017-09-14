class Interface

  attr_accessor :current_language, :locales

  FEATURE_OPTION_MAJOR_STATES     = 1
  FEATURE_OPTION_AVERAGE_POP      = 2
  FEATURE_OPTION_BOUNDARY_CITIES  = 3
  FEATURE_OPTION_EXIT             = 4

  # Interface run method will display available features to the user.
  def run
    # Locale supported: english for now.
    self.current_language = 'en'
    load_locales if locales.nil?

    # Loading data source from the endpoint
    load_data_source
    present_menu
  end

  def load_locales
    self.locales = YAML::load_file("./locales/#{current_language}.yml")[current_language]
  end

  def load_data_source(force = false)
    # Memoizing, load only once.
    return @data_source unless @data_source.nil? || force
    puts t('loading_zipcodes')

    # Loading data into memory, from source url based in settings.yml file
    @data_source = DataSource.new(SETTINGS['data_source'])
    exit if @data_source.raw_data.nil?
    @data_source.load_states

    puts t('done')
    @data_source
  end

  def data_source
    @data_source
  end

  def puts(*args)
    return if APP_ENV == 'test'
    super(args)
  end

  # Translate method
  def t(term, vars = {})
    return '' if current_language.nil?

    term = self.locales[term]
    vars.map{|key, value| term.gsub!("{#{key}}", value.to_s)}
    term
  end

  # Displays options for the user
  def present_menu
    puts "-------------------"
    puts t('select_features')
    puts t('feature_one')
    puts t('feature_two')
    puts t('feature_three')
    puts t('exit_option')

    selected_feature = gets.to_i

    case selected_feature
    when FEATURE_OPTION_MAJOR_STATES
      print_major_states
    when FEATURE_OPTION_AVERAGE_POP
      print_average_population_for_state
    when FEATURE_OPTION_BOUNDARY_CITIES
      print_boundary_cities_for_state
    when FEATURE_OPTION_EXIT
      return
    else
      puts t('invalid_option', option: selected_feature)
      run
    end
  end

  def get_state
    gets.strip.upcase
  end

  def invalid_state?(state)
    data_source.states[state].nil?
  end

  def major_states_json
    data_source.major_states.to_json
  end

  def print_major_states
    puts major_states_json
  end

  def average_population_for_state_json
    data_source.average_population_for_state(state).to_json
  end

  def print_average_population_for_state
    puts t('enter_state')
    state = get_state

    if invalid_state?(state)
      puts t('invalid_state')
      average_population_for_state
    else
      puts average_population_for_state_json
    end
  end

  def boundary_cities_for_state_json
    data_source.boundary_cities_for_state(state).to_json
  end

  def print_boundary_cities_for_state
    puts t('enter_state')
    state = get_state

    if invalid_state?(state)
      puts t('invalid_state')
      boundary_cities_for_state
    else
      puts boundary_cities_for_state_json
    end
  end

end
