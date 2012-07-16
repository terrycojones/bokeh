asyncTest('test_datarange1d', ->
  # Bokeh.Collections['ObjectArrayDataSource'].on('create', () ->
  #   console.log('create'))

  data_source = Bokeh.Collections['ObjectArrayDataSource'].create({
  	data : [{x : 1, y : -2},
    	{x : 2, y : -3},
  		{x : 3, y : -4},
  		{x : 4, y : -5},
  		{x : 5, y : -6}]
  });
  datarange = Bokeh.Collections['DataRange1d'].create({
      'sources' : [{'ref' : data_source.ref(), 'columns' : ['x', 'y']}]
      'rangepadding' : 0.0
  })
  _.defer(() ->
    ok(datarange.get('start') == -6)
    ok(datarange.get('end') == 5)
    data_source.set('data', [{x : 1, y : -2},
      	{x : 2, y : -3},
    		{x : 3, y : -4},
    		{x : 4, y : -5},
    		{x : 5, y : -100}])
    ok(datarange.get('start') == -100)
    ok(datarange.get('end') == 5)
    start()
  )
)

asyncTest('test_datarange1d_multiple_sources', ->
  # Bokeh.Collections['ObjectArrayDataSource'].on('create', () ->
  #   console.log('create'))

  data_source = Bokeh.Collections['ObjectArrayDataSource'].create({
  	data : [{x : 1, y : -2},
    	{x : 2, y : -3},
  		{x : 3, y : -4},
  		{x : 4, y : -5},
  		{x : 5, y : -6}]
  });
  data_source2 = Bokeh.Collections['ObjectArrayDataSource'].create({
  	data : [{xx : 10, yy : -20},
    	{xx : 20, yy : -30},
  		{xx : 30, yy : -40},
  		{xx : 40, yy : -50},
  		{xx : 50, yy : -60}]
  });
  datarange = Bokeh.Collections['DataRange1d'].create({
      'sources' : [
        {'ref' : data_source.ref(), 'columns' : ['x', 'y']},
        {'ref' : data_source2.ref(), 'columns' : ['yy']},
      ],
      'rangepadding' : 0.0
  })
  _.defer(() ->
    ok(datarange.get('start') == -60)
    ok(datarange.get('end') == 5)
    data_source.set('data', [{x : 1, y : -2},
      	{x : 2, y : -3},
    		{x : 3, y : -4},
    		{x : 4, y : -5},
    		{x : -100, y : 0}])
    data_source2.set('data', [{x : 1, yy : 1000}])
    ok(datarange.get('start') == -100)
    ok(datarange.get('end') == 1000)
    start()
  )
)

asyncTest('test_datarange1d_can_be_overriden', ->
  # Bokeh.Collections['ObjectArrayDataSource'].on('create', () ->
  #   console.log('create'))

  data_source = Bokeh.Collections['ObjectArrayDataSource'].create({
  	data : [{x : 1, y : -2},
    	{x : 2, y : -3},
  		{x : 3, y : -4},
  		{x : 4, y : -5},
  		{x : 5, y : -6}]
  });
  data_source2 = Bokeh.Collections['ObjectArrayDataSource'].create({
  	data : [{xx : 10, yy : -20},
    	{xx : 20, yy : -30},
  		{xx : 30, yy : -40},
  		{xx : 40, yy : -50},
  		{xx : 50, yy : -60}]
  });
  datarange = Bokeh.Collections['DataRange1d'].create({
      'sources' : [
        {'ref' : data_source.ref(), 'columns' : ['x', 'y']},
        {'ref' : data_source2.ref(), 'columns' : ['yy']},
      ],
      'rangepadding' : 0.0
  })
  _.defer(() ->
    ok(datarange.get('start') == -60)
    ok(datarange.get('end') == 5)
    datarange.set({'start' : 1, 'end' : 10})
    ok(datarange.get('start') == 1)
    ok(datarange.get('end') == 10)
    start()
  )
)

test('test_linear_mapper', ->
  range1 = Bokeh.Collections['Range1d'].create({'start' : 0, 'end' : 1})
  range2 = Bokeh.Collections['Range1d'].create({'start' : 0, 'end' : 2})
  mapper = Bokeh.Collections['LinearMapper'].create({
    'data_range' : range1.ref(),
    'screen_range' : range2.ref()
  })
  mapper.dinitialize()
  ok(mapper.map_screen(0.5) == 1)
  ok(mapper.map_screen(0) == 0)
  ok(mapper.map_screen(1) == 2)
  ok(mapper.map_data(1) == 0.5)
  ok(mapper.map_data(0) == 0)
  ok(mapper.map_data(2) == 1)
)


test('renderer_selection', ->
  data_source = Bokeh.Collections['ObjectArrayDataSource'].create({
    data : [{x : 1, y : -2},
      {x : 2, y : -3},
      {x : 3, y : -4},
      {x : 4, y : -5},
      {x : 5, y : -6}]
  }, {'local' : true})
  container = Bokeh.Collections['InteractiveContext'].create(
    {}, {'local' : true});
  plot = Bokeh.scatter_plot(container, data_source, 'x', 'y', 'x', 'circle')
  scatterrenderer = plot.resolve_ref(plot.get('renderers')[0])
  plot.dinitialize()
  scatterrenderer.dinitialize()
  scatterrenderer.get_ref('xmapper').get_ref('data_range').dinitialize()
  scatterrenderer.get_ref('xmapper').dinitialize()
  scatterrenderer.get_ref('ymapper').get_ref('data_range').dinitialize()
  scatterrenderer.get_ref('ymapper').dinitialize()
  selected = scatterrenderer.select([0, 200], null)
  deepEqual(selected, _.range(5))
  selected = scatterrenderer.select(null, [0, 200])
  deepEqual(selected, _.range(5))
  select = scatterrenderer.select([0, 120], null)
  deepEqual(select, _.range(3))
  select = scatterrenderer.select([0, 120], [80, 200])
  deepEqual(select, _.range(3))

)