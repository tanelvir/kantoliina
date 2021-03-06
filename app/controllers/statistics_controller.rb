#encoding: utf-8
##
# The controller for the statistics page

class StatisticsController < ApplicationController

  ##
  # Initializes the statistics variables, calls the counting method and renders the statistics page

  def index

    @members = Member.includes(:membergroup)
    @active = 0
    @deleted = 0
    @total = 0
    @membersdate
    @paidthisyear = 0
    @membergroups = Hash.new
    @municipalities = Hash.new
    count_stuff

    if params[:startdate]
      @startdate = params[:startdate]
      @enddate = params[:enddate]

      if params[:startdate] == ""
        startdateQ = "1900-01-01 00:00"
      else
        startdateQ = params[:startdate]
      end

      if params[:enddate] == ""
        enddateQ = Time.now.to_s
      else
        enddateQ = params[:enddate] + " 23:59"
      end
      startdateQ = startdateQ.gsub(/[\/]/, '-')
      enddateQ = enddateQ.gsub(/[\/]/, '-')
      #@membersdate = Member.where("created_at >= :a AND created_at <= :b AND active = 't'", :a => @startdate, :b => @enddate)
      #@membersdate = Member.where("created_at BETWEEN :a AND :b", :a => @startdate + "", :b => @enddate + "23:59")
      @membersdate = Member.all(:conditions => ["active = 't' AND created_at BETWEEN ? AND ?", startdateQ, enddateQ], :order => "membernumber")
    end

  end


  private
  ##
  # Counts the statistics shown in the statistics page
  def count_stuff
    @members.each do |member|
      if member.active
        @active += 1
        if member.paymentstatus && member.membershipyear.to_i == Time.now.year.to_i
          @paidthisyear += 1
        end

        if !member.membergroup.onetimefee || member.membershipyear.to_i == Time.now.year.to_i
          @total += member.membergroup.fee
        end

        if @membergroups[member.membergroup.name.to_sym]
          @membergroups[member.membergroup.name.to_sym] = @membergroups[member.membergroup.name.to_sym] + 1
        else
          @membergroups[member.membergroup.name.to_sym] = 1
        end

        if @municipalities[member.municipality.to_sym]
          @municipalities[member.municipality.to_sym] = @municipalities[member.municipality.to_sym] + 1
        else
          @municipalities[member.municipality.to_sym] = 1
        end

      else
        @deleted += 1
      end

    end
    @municipalities = @municipalities.sort_by { |key, value| value }.reverse
  end


end

