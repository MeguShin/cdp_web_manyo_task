class LabelsController < ApplicationController
    before_action :set_label, only:[:show, :edit, :update, :destroy]
    # ラベル一覧表示をするためにラベルの全ての情報を取得
    def index
        #@labels = Label.all
        @labels = current_user.labels
    end
    # ラベルの登録準備
    def new
        @label = Label.new
    end
    # ラベルの登録
    def create
        # @label = Label.new(label_params)
        @label = current_user.labels.build(label_params)
        if @label.save
            redirect_to labels_path, notice: t('.created') #ラベル登録後、ラベル一覧画面にとぶ
        else
            render :new
        end
    end
 
    def show
    end

    def edit
    end

    def update
        if @label.update(label_params)
          redirect_to labels_path, notice: t('.updated')
        else
          render :edit
        end
    end

    def destroy
        @label.destroy
        redirect_to labels_path, notice: t('.destroyed')
    end

    private

    def set_label
        #@label = Label.find(params[:id])
        @label = current_user.labels.find(params[:id])
    end

    def label_params
        params.require(:label).permit(:name)
    end
end
