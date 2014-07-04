#!/usr/bin/ruby
# encoding: utf-8

require 'net/ssh'
require 'net/sftp'
require_relative 'dsl'
require_relative 'result'
require_relative 'teacher'
require_relative 'utils'

class Case
	include DSL
	include Utils
	attr_accessor :result

	def initialize(pConfig)
		@global=Teacher.instance.global
		@config=pConfig
		@tests=Teacher.instance.tests
				
		#Define Report datagroup
		@datagroup = Teacher.instance.report.new_datagroup
		@datagroup.head.merge! @config
		@datagroup.tail[:unique_fault]=0
		@caseId = @datagroup.order

		#Default configuration
		@config[:tt_skip] = @config[:tt_skip] || false
		@mntdir = File.join( "var", @global[:tt_testname], "mnt", @caseId.to_s )
		@tmpdir = File.join( "var", @global[:tt_testname], "tmp", @caseId.to_s )
		@remote_tmpdir = File.join( "/", "tmp" )

		ensure_dir @mntdir
		ensure_dir @tmpdir

		@unique_values={}
		@result = Result.new
		@result.reset

		@debug=Teacher.instance.is_debug?
		@verbose=Teacher.instance.is_verbose?
	
		@action_counter=0		
		@action={ :id => 0, :weight => 1.0, :description => 'Empty description!'}
		tempfile :default
		
	end

	def start
		lbSkip=@config[:tt_skip]||false
		if lbSkip==true then
			verbose "Skipping case <"+@config[:tt_members]+">\n"
			return false
		end

		r=`ls #{@tmpdir}/*.tmp | wc -l 2>/dev/null`
		execute("rm #{@tmpdir}/*.tmp") if r[0].to_i>0 #Detele previous temp files
		
		if @global[:tt_sequence] then
			verboseln "\nStarting case <"+get(:tt_members)+">"
			@tests.each do |t|
				verbose "* Processing <"+t[:name].to_s+"> "
				instance_eval &t[:block]
				verbose "\n"
			end
		else
			@tests.each { |t| instance_eval &t[:block] }
		end
		
		@datagroup.close
		verboseln "\n"
	end

	#Read param pOption from config or global Hash data
	def get(pOption)
		return @config[pOption] if @config[pOption]
		return @global[pOption] if @global[pOption]
		return nil
	end

end
