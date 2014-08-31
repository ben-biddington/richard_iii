class SpyInternet
  def initialize
    @requests = []
  end

  def execute(request)
    @requests << request
    @response
  end

  def must_have_been_asked_to_execute(what)
    @requests.any?{|it| it.eql? what}.must_be :==, true, "Unable to locate match for:\n\n#{what.inspect}\n\nin:\n\n#{@requests.inspect}"
  end

  def always_return(response)
    @response = response
  end
end
