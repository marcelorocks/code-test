require './spec/spec_helper.rb'

describe Interface do

  let(:subject){Interface.new}
  let(:fake_source){"http://somesource/a.json"}

  before :each do
    expect(RestClient).to receive(:get).with(fake_source).and_return(test_data)
    @data_source = DataSource.new(fake_source)
  end

  context 'When running the Interface' do

    it 'should run, loading data source and presenting the menu' do
      expect(subject).to receive(:load_data_source).and_return(true)
      expect(subject).to receive(:present_menu).at_least(1).and_return(true)

      subject.run
    end

    it 'should run feature 1 if option 1 is selected' do
      expect(subject).to receive(:gets).and_return('1')
      expect(subject).to receive(:print_major_states)

      subject.present_menu
    end

    it 'should run feature 2 if option 2 is selected' do
      expect(subject).to receive(:gets).and_return('2')
      expect(subject).to receive(:print_average_population_for_state)

      subject.present_menu
    end

    it 'should run feature 3 if option 3 is selected' do
      expect(subject).to receive(:gets).and_return('3')
      expect(subject).to receive(:print_boundary_cities_for_state)

      subject.present_menu
    end

    it 'should load the data source' do
      expect(DataSource).to receive(:new).with("http://media.mongodb.org/zips.json").and_return(@data_source)
      subject.load_data_source
    end

    it 'should present proper data for print_major_states' do
      expect(DataSource).to receive(:new).with("http://media.mongodb.org/zips.json").and_return(@data_source)
      subject.load_data_source
      expect(subject.major_states_json).to eql(%{[{\"name\":\"CA\",\"population\":45000000,\"cities\":2,\"average_population\":22500000}]})
    end

    it 'should present proper data for print_average_population_for_state' do
      expect(DataSource).to receive(:new).with("http://media.mongodb.org/zips.json").and_return(@data_source)
      expect(subject).to receive(:state).and_return('CA')
      subject.load_data_source
      expect(subject.average_population_for_state_json).to eql("{\"name\":\"CA\",\"population\":45000000,\"cities\":2,\"average_population\":22500000}")
    end

    it 'should present proper data for print_average_population_for_state' do
      expect(DataSource).to receive(:new).with("http://media.mongodb.org/zips.json").and_return(@data_source)
      expect(subject).to receive(:state).and_return('CA')
      subject.load_data_source
      expect(subject.boundary_cities_for_state_json).to eql("{\"name\":\"CA\",\"population\":45000000,\"cities\":2,\"average_population\":22500000,\"biggest_city\":{\"name\":\"Livermore\",\"population\":43000000},\"smallest_city\":{\"name\":\"Mountain View\",\"population\":2000000}}")
    end

  end

end
